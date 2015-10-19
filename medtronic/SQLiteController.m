//
//  SQLiteController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "SQLiteController.h"
#import "Element.h"
#import "Settings.h"
#import "Ingredient.h"
#import "ElementSerializable.h"
#import "JSON.h"
#import "CategorySerializable.h"
#import "Utils.h"
#import "SQLQuery.h"

@implementation SQLiteController

+ (SQLiteController *) sharedSingleton{
    static SQLiteController * singleton;
	
	@synchronized(self){
		if (!singleton) {
			singleton = [[SQLiteController alloc] init];
		}
		return singleton;
	}
}


- (id)init{
    self = [super init];
    
    // Setup some globals
	databaseFile = @"medd.db";
    
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent: databaseFile];
    
    return self;
}


- (BOOL) createDatabaseIfNeeded {
    
    //NSFileManager *filemgr = [NSFileManager defaultManager];
    //if ([filemgr fileExistsAtPath: databasePath ] == NO){
	
	if (![Settings sharedSingleton].databaseCreated) {
    
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &database) == SQLITE_OK){
            
            [self execFromScript:@"medtronic"];
            [self execFromScript:@"categories"];
            [self execFromScript:@"products"];
            [self execFromScript:@"dishes"];
            
            /*
            // sprawdzmy
            const char *sql = "SELECT id, name from CATEGORY";
            sqlite3_stmt *selectstmt;
            if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
                
                while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                    
                    NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
                    NSLog(@"id: %d\tname: %@", primaryKey, [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)]);
                }
            }*/
            [Settings sharedSingleton].databaseCreated = YES;
            [[Settings sharedSingleton] save];
            sqlite3_close(database);
            
        } else {
           NSLog(@"Failed to open/create database");
            return NO;
        }
    }else{
        //[filemgr removeItemAtPath:databasePath error:nil];
        //NSLog(@"remove");
        //const char * dbpath = [databasePath UTF8String];
        //sqlite3_open(dbpath, &database);
    }
    return YES;
}

- (BOOL) execFromScript: (NSString *) fileName{
    
    NSLog(@"Beginning transaction");
    sqlite3_exec(database, "BEGIN TRANSACTION;", NULL, NULL, NULL);
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource: fileName ofType:@"sql"];
    NSError * error = nil;
    NSString * allString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: &error];

    NSLog(@"%@", allString);
    const char* cString = [allString cStringUsingEncoding: NSUTF8StringEncoding];
    sqlite3_exec(database, cString, 0, 0, 0);
    
    NSLog(@"Committing transaction");
    char *errMsg;
    
    if(sqlite3_exec(database, "COMMIT TRANSACTION;", NULL, NULL, &errMsg)== SQLITE_OK) {
        NSLog(@"commit ok");
        return YES;
    }
    else{
        if (errMsg != nil) {
            NSLog(@"%s", errMsg);
        }
        return NO;
    }
}

- (NSArray *) execSelect: (NSString *) sel getObjectsLike: (MedtronicObject *) obj for: (id<SQLiteControllerDelegate>) del{
    
    const char *sql = [sel cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray * toReturn = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSLog(@"ok: %@", sel);
    
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                
                MedtronicObject * virtual = [obj clone];
                
                NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
                NSString * str = [NSString stringWithUTF8String: (char *)sqlite3_column_text(selectstmt, 1)];
                
                [virtual fillWithId: primaryKey andName:str moreIfNecessary: selectstmt];
                [toReturn addObject: virtual];
            }
        }
        sqlite3_finalize(selectstmt);
        sqlite3_close(database);
    }
        
    [del didReceiveArray: toReturn];
    return toReturn;
}

- (BOOL) hasElementsLike: (NSString *) sel{
    sqlite3_stmt *selectstmt = [self openDatabaseAndQuery: sel];
    if (selectstmt == nil) {
        return NO;
    }
    if(sqlite3_step(selectstmt) == SQLITE_ROW) {
        [self closeDatabase: selectstmt];
        return YES;
    }
    return NO;
}

- (MedtronicObject *) execSelect: (NSString *) sel fillObject: (MedtronicObject *)obj{
    
    sqlite3_stmt *selectstmt = [self openDatabaseAndQuery: sel];
    if (selectstmt == nil) {
        return obj;
    }
    if(sqlite3_step(selectstmt) == SQLITE_ROW) {
        
        [obj fillWithMoreInfo:  selectstmt];
    }
    [self closeDatabase: selectstmt];
    return obj;
}


- (int) getNextElementIdAndUpdate:(BOOL)update{
    
    sqlite3_stmt *selectstmt = [self openDatabaseAndQuery: @"SELECT next_element_id FROM IDENTIFY WHERE id=1;"];
    if (selectstmt == nil) {
        return -1;
    }
    int next = -1;
    if(sqlite3_step(selectstmt) == SQLITE_ROW) {
        next = sqlite3_column_int(selectstmt, 0);
        NSLog(@"NEXT ELEMENT ID: %d", next);
    }
    else{
        return -1;
    }
    [self closeDatabase: selectstmt];
    
    if (update) {
        // lets update next id
        [self commitTransaction: [NSString stringWithFormat: @"UPDATE IDENTIFY SET next_element_id=%d  WHERE id=1;", (next+1)]];
    }
    
    return next;
}

- (int)getNextElementId{
    return [self getNextElementIdAndUpdate:YES];
}

- (int) getNextCategoryIdAndUpdate:(BOOL)update{
    
    sqlite3_stmt *selectstmt = [self openDatabaseAndQuery: @"SELECT next_category_id FROM IDENTIFY WHERE id=1;"];
    if (selectstmt == nil) {
        return -1;
    }
    int next = -1;
    if(sqlite3_step(selectstmt) == SQLITE_ROW) {
        next = sqlite3_column_int(selectstmt, 0);
        NSLog(@"NEXT CAT ID: %d", next);
    }
    else{
        return -1;
    }
    [self closeDatabase: selectstmt];
    
    
    // lets update next id
    if (update) {
        [self commitTransaction: [NSString stringWithFormat: @"UPDATE IDENTIFY SET next_category_id=%d  WHERE id=1;", (next+1)]];
    }
    
    return next;
}

- (int)getNextCategoryId{
    return [self getNextCategoryIdAndUpdate:YES];
}


- (NSArray *) getAllIngredientsFor: (int) theId{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    NSString * sel = [NSString stringWithFormat: @"SELECT * FROM ELEMENT JOIN ELEMENT_HAS_ELEMENT ON ELEMENT.id = ELEMENT_HAS_ELEMENT.id_child WHERE ELEMENT_HAS_ELEMENT.id_parent=%d ORDER BY name COLLATE NOCASE", theId];
    
    // let's get elements
    const char *sql = [sel cStringUsingEncoding:NSUTF8StringEncoding];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSLog(@"ok: %@", sel);
        
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
                //NSLog(@"znalazlo cos");
                Element * virtual = [[Element alloc] init];
                
                NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
                NSString * str = [NSString stringWithUTF8String: (char *)sqlite3_column_text(selectstmt, 1)];
                
                [virtual fillWithId: primaryKey andName:str moreIfNecessary:selectstmt];
                [virtual fillWithMoreInfo: selectstmt];
                
                Ingredient * ing = [[Ingredient alloc] initWithWeight:sqlite3_column_double(selectstmt, 20)  andElement:virtual];
                [arr addObject: ing];
            }
        }
        sqlite3_finalize(selectstmt);
        sqlite3_close(database);
    }

    // now let's make ingredients of them    
    return arr;
}

- (NSArray *) getAllCategoryIdsFor: (int) theId{
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    NSString * sel = [NSString stringWithFormat: @"SELECT id FROM CATEGORY JOIN ELEMENT_HAS_CATEGORY ON CATEGORY.id = ELEMENT_HAS_CATEGORY.id_category WHERE ELEMENT_HAS_CATEGORY.id_element=%d", theId];
    
    sqlite3_stmt *selectstmt = [self openDatabaseAndQuery: sel];
    while(sqlite3_step(selectstmt) == SQLITE_ROW) {
        
        NSInteger catId = sqlite3_column_int(selectstmt, 0);
        [arr addObject: [NSNumber numberWithInt: catId ]];
    }
    if (!selectstmt) {
        [self closeDatabase: selectstmt];
    }
    
    return arr;
}


- (sqlite3_stmt *) openDatabaseAndQuery: (NSString *) sel{
    const char *sql = [sel cStringUsingEncoding:NSUTF8StringEncoding];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSLog(@"ok: %@", sel);
        
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK){
            return selectstmt;
        }
    }
    return nil;
}

- (void) closeDatabase: (sqlite3_stmt *) selectstmt{
    sqlite3_finalize(selectstmt);
    sqlite3_close(database);
}

- (BOOL) commitTransaction: (NSString *) sel{
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        sqlite3_exec(database, "BEGIN TRANSACTION;", NULL, NULL, NULL);
        
        const char* cString = [sel cStringUsingEncoding: NSUTF8StringEncoding];
        sqlite3_exec(database, cString, 0, 0, 0);
        
        //NSLog(@"Committing transaction");
        char *errMsg;
        
        if(sqlite3_exec(database, "COMMIT TRANSACTION;", NULL, NULL, &errMsg)== SQLITE_OK) {
            NSLog(@"commit ok");
        }
        else{
            if (errMsg != nil) {
                NSLog(@"ERR: %s", errMsg);
                return NO;
            }
        }
    }
    return YES;
}

- (NSString *) serializeDatabase{
    
    NSMutableDictionary * finalDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableArray * elements = [[NSMutableArray alloc] init];
    NSMutableArray * categories = [[NSMutableArray alloc] init];
    NSMutableArray * favouritesNotUsers = [[NSMutableArray alloc] init];
    
    NSMutableArray * elementsArray = (NSMutableArray *)[self execSelect:@"SELECT * FROM ELEMENT WHERE is_user_defined='1';" getObjectsLike:[[ElementSerializable alloc] init] for:nil];
    
    for (ElementSerializable * el in elementsArray) {
        NSDictionary * singleEl = [el prepareSerializedObject];
        [elements addObject: singleEl];
    }
    
    NSMutableArray * catsArray = (NSMutableArray *)[self execSelect:@"SELECT * FROM CATEGORY WHERE is_user_defined='1';" getObjectsLike:[[CategorySerializable alloc] init] for:nil];
    
    for (CategorySerializable * el in catsArray) {
        NSDictionary * singleEl = [el prepareSerializedObject];
        if (singleEl) {
            [categories addObject: singleEl];
        }
    }
    
    NSArray * favElements = [self execSelect:@"SELECT * FROM ELEMENT WHERE is_user_defined='0' AND is_favourite='1';" getObjectsLike: [[ElementSerializable alloc] init] for:nil];
    for (ElementSerializable * el in favElements) {
        [favouritesNotUsers addObject: [NSNumber numberWithInt: el.theid]];
    }
    
    [finalDictionary setObject: elements forKey:@"elements"];
    [finalDictionary setObject: categories forKey:@"categories"];
    [finalDictionary setObject: favouritesNotUsers forKey:@"favs"];
    
    int nextCatId = [self getNextCategoryIdAndUpdate:NO];
    int nextElId = [self getNextElementIdAndUpdate:NO];
    
    [finalDictionary setObject: [NSNumber numberWithInt:nextElId] forKey:@"next_el_id"];
    [finalDictionary setObject: [NSNumber numberWithInt:nextCatId] forKey:@"next_cat_id"];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonString = [jsonWriter stringWithObject:finalDictionary];  
#if DEBUG
    NSLog(@"SAVE:\n%@", jsonString);
#endif
    return jsonString;
}

- (BOOL) loadDatabase: (NSString *) jsonStr{

    NSDictionary * json = nil;
    @try {
        json = [Utils getJSONFromString:jsonStr];
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        if (json == nil) {
            return NO;
        }
    }
    
    NSArray * elements = [json objectForKey:@"elements"];
    NSArray * categories = [json objectForKey:@"categories"];
    NSArray * favs = [json objectForKey:@"favs"];
    
#if DEBUG
    NSLog(@"I got %d categories and %d elements and %d favourites", [categories count], [elements count], [favs count]);
#endif
    
    ///////// REMOVE
    NSMutableString * allRemoveSql = [[NSMutableString alloc] init];
    
    // let's get all userdefined
    NSMutableArray * allArray = (NSMutableArray *)[self execSelect:@"SELECT * FROM ELEMENT WHERE is_user_defined=1 ORDER BY type DESC;" getObjectsLike:[[ElementSerializable alloc] init] for:nil];
    
    for (ElementSerializable * singleElement in allArray) {
        [allRemoveSql appendString: [SQLQuery sqlRemoveElement: singleElement.theid]];
    }
    
    // now all user defined categories
    NSMutableArray * catsArray = (NSMutableArray *)[self execSelect:@"SELECT * FROM CATEGORY WHERE is_user_defined=1 ORDER BY depth DESC;" getObjectsLike:[[CategorySerializable alloc] init] for:nil];
    
    for (CategorySerializable * singleElement in catsArray) {
        [allRemoveSql appendString: [SQLQuery sqlRemoveCategory: singleElement.theid]];
    }
    
    
    // remove them all
    if (![self commitTransaction: allRemoveSql]) {
        return NO;
    }
    
    // remove favourites
    [self commitTransaction: @"UPDATE ELEMENT SET is_favourite='0'"];
    
    //////////// ADD
    // now deserialization
    NSMutableString * allDeserialized = [[NSMutableString alloc] init];
    
    for (NSDictionary * singleCategory in categories) {
        CategorySerializable * el = [[CategorySerializable alloc] init];
        NSString * str = [el deserializeFromJson: singleCategory];
        if (str) {
            [allDeserialized appendString:str];
        }
        else{
            NSLog(@"BLAD PRZY DESERIALIZACJI!: %d", el.theid);
            return NO;
        }
    }
    
    for (NSDictionary * singleElement in elements) {
        ElementSerializable * el = [[ElementSerializable alloc] init];
        NSString * str = [el deserializeFromJson: singleElement];
        if (str) {
            [allDeserialized appendString:str];
        }
        else{
            NSLog(@"BLAD PRZY DESERIALIZACJI!: %d", el.theid);
            return NO;
        }
    }
    
    int nextCatId = [Utils getIntFromDict:json forKey:@"next_cat_id"];
    int nextElId = [Utils getIntFromDict:json forKey:@"next_el_id"];
    
    [allDeserialized appendFormat:@"UPDATE IDENTIFY SET next_category_id=%d  WHERE id=1; UPDATE IDENTIFY SET next_element_id=%d  WHERE id=1;", nextCatId, nextElId];
    
    if (![self commitTransaction: allDeserialized]) {
        return NO;
    }
    
    NSMutableString * strId = [[NSMutableString alloc] init];
    //now let's set favourite ones
    for (int i = 0; i < favs.count; ++i) {
        
        [strId appendFormat: @"%d", [favs[i] intValue]];
        if (i+1 < favs.count) {
            [strId appendFormat:@","];
        }
    }
    
    if ([strId length] > 0) {
        NSString * updateFavs = [NSString stringWithFormat:@"UPDATE ELEMENT SET is_favourite='1' WHERE id IN (%@)", strId];
        if (![self commitTransaction: updateFavs]) {
            return NO;
        }
    }
    
    return YES;
}


@end
