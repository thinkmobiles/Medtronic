//
//  Settings.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-18.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>

static
@interface Settings : NSObject{
    float maxWeight;
    NSString * uuid;
    int runCounter;
    
    BOOL databaseCreated;
}

@property BOOL databaseCreated;
@property float maxWeight;
@property int runCounter;
@property BOOL showConditions;
@property (nonatomic, retain) NSString * uuid;

+ (Settings *) sharedSingleton;
- (void) save;
- (void) load;
- (void) plusRunCounter;


@end
