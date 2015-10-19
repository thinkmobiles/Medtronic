//
//  MedtronicObject.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define PRODUCT 1
#define DISH 2
#define MEAL 3
#define DISH_PRODUCT 4

@interface MedtronicObject : NSObject{

    int theid;
    NSString * name;

}
@property int theid;
@property (nonatomic, retain) NSString * name;


- (id) initWithId: (int) _theid andName: (NSString *) _name;
- (MedtronicObject *) clone;
- (void) fillWithId: (int) _theid andName: (NSString *) _name moreIfNecessary: (sqlite3_stmt*) selectstmt; 
- (void) fillWithMoreInfo: (sqlite3_stmt *) details;

@end
