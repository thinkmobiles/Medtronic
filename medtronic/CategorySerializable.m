//
//  CategorySerializable.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-04.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "CategorySerializable.h"
#import "SQLiteController.h"
#import "Utils.h"

@implementation CategorySerializable

@synthesize isInto;

- (id)init{
    self = [super init];
    isInto = NO;
    return self;
}

- (id)initWithId:(int)_theid andName:(NSString *)_name{
    self = [super initWithId:_theid andName:_name];
    isInto = NO;
    return self;
}

- (void) fillWithMoreInfo: (sqlite3_stmt *) details{
    [super fillWithMoreInfo:details];
    
}

- (void)fillWithId:(int)_theid andName:(NSString *)_name moreIfNecessary:(sqlite3_stmt *)selectstmt{
    [super fillWithId:_theid andName:_name moreIfNecessary:selectstmt];
}

- (MedtronicObject *)clone{
    return [[CategorySerializable alloc] init];
}


- (NSDictionary *) prepareSerializedObject{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    if (depth > 1) {
        
        NSArray * parent = [[SQLiteController sharedSingleton] execSelect: [NSString stringWithFormat: @"SELECT * FROM CATEGORY JOIN CATEGORY_HAS_CATEGORY ON CATEGORY.id = CATEGORY_HAS_CATEGORY.id_parent WHERE CATEGORY_HAS_CATEGORY.id_child=%d", theid] getObjectsLike:[[CategorySerializable alloc] init] for: nil];
        
        if ([parent count] > 0 && !((CategorySerializable *)[parent objectAtIndex:0]).isUserDefined) {
            
            // if my parent is not user defined, then this one will not be included in its parent's table
            
            [dict setObject: [NSNumber numberWithInt: ((CategorySerializable *)[parent objectAtIndex:0]).theid] forKey:@"parent"];
        }
        else if(!isInto){
            return nil;
        }
    }
    
    // let's set all the info
    
    [dict setObject: [NSNumber numberWithInt: theid] forKey:@"id"];
    [dict setObject: name forKey:@"name"];
    
    [dict setObject: [NSNumber numberWithInt: depth] forKey:@"depth"];
    [dict setObject: [NSNumber numberWithInt: type] forKey:@"type"];
    
    // and get subcategories
    if (!subCategories) {
        subCategories = [[NSMutableArray alloc] init];
    }
    [subCategories removeAllObjects];
    NSArray * children = [[SQLiteController sharedSingleton] execSelect: [NSString stringWithFormat: @"SELECT * FROM CATEGORY JOIN CATEGORY_HAS_CATEGORY ON CATEGORY.id = CATEGORY_HAS_CATEGORY.id_child WHERE CATEGORY_HAS_CATEGORY.id_parent=%d", theid] getObjectsLike:[[CategorySerializable alloc] init] for: nil];
    
    //NSLog(@"ME: %@ children: %d", name, [children count]);
    if ([children count] > 0) {
        
        for (CategorySerializable * singleOne in children) {
            if (!singleOne.isUserDefined) {
                continue;
            }
            singleOne.isInto = YES;
            NSDictionary * sub = [singleOne prepareSerializedObject];
            if (sub) {
                [subCategories addObject: sub];
            }
        }
    }
    [dict setObject:subCategories forKey:@"categories"];
    
    return dict;
}

- (NSString *) deserializeFromJson:(NSDictionary *)dict{
    theid = [Utils getIntFromDict: dict forKey:@"id"];
    name = [Utils getStringFromDict: dict forKey:@"name"];
    depth = [Utils getIntFromDict: dict forKey: @"depth"];
    type = [Utils getIntFromDict:dict forKey:@"type"];
    
    // let's add it
    NSMutableString * addSql = [NSMutableString stringWithFormat:@"INSERT INTO category VALUES ('%d','%@','%d','%d','1');", theid, name, type, depth];
    
    NSArray * subCats = [dict objectForKey:@"categories"];
    subCategories = [[NSMutableArray alloc] init];
    
    if (subCats && [subCats count] > 0) {
        
        for (NSDictionary * sub in subCats) {
            CategorySerializable * cat = [[CategorySerializable alloc] init];
            NSString * subStr = [cat deserializeFromJson: sub];
            [subCategories addObject: cat];
            
            [addSql appendString: subStr];
            // not the connection between
            [addSql appendFormat:@"INSERT INTO category_has_category VALUES ('%d','%d');", cat.theid, theid];
        }
    }
    return addSql;
}

@end
