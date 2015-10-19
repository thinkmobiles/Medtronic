//
//  SQLiteController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> // Import the SQLite database framework
#import "MedtronicObject.h"

@protocol SQLiteControllerDelegate <NSObject>

@optional
- (void) didReceiveArray: (NSMutableArray *) arr;

@end

static

@interface SQLiteController : NSObject{
    NSString * databaseFile;
	NSString * databasePath;
    
    sqlite3 * database;
    
    id<SQLiteControllerDelegate> delegate;
}


+ (SQLiteController *) sharedSingleton;
- (BOOL) createDatabaseIfNeeded;
- (BOOL) execFromScript: (NSString *) fileName;

- (NSArray*) execSelect: (NSString *) sel getObjectsLike: (MedtronicObject *) obj for: (id<SQLiteControllerDelegate>) del;
- (MedtronicObject *) execSelect: (NSString *) sel fillObject: (MedtronicObject *)obj;
- (BOOL) hasElementsLike: (NSString *) sel;

- (int) getNextElementId;
- (int) getNextCategoryId;

- (int) getNextElementIdAndUpdate: (BOOL) update;
- (int) getNextCategoryIdAndUpdate: (BOOL) update;

- (NSArray *) getAllIngredientsFor: (int) theId;
- (NSArray *) getAllCategoryIdsFor: (int) theId;

- (void) closeDatabase: (sqlite3_stmt *) selectstmt;
- (sqlite3_stmt *) openDatabaseAndQuery: (NSString *) sel;
- (BOOL) commitTransaction: (NSString *) sel;
//- (MedtronicObject *) execSelect: (NSString *) sel createObjectLike: (MedtronicObject *)obj;

- (NSString *) serializeDatabase;
- (BOOL) loadDatabase: (NSString *) jsonStr;

@end
