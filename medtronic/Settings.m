//
//  Settings.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-18.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Settings.h"

@implementation Settings


@synthesize uuid,maxWeight, runCounter, databaseCreated;


+ (Settings *) sharedSingleton{
    static Settings * singleton;
	
	@synchronized(self){
		if (!singleton) {
			singleton = [[Settings alloc] init];
		}
		return singleton;
	}
}


- (id)init{
    self = [super init];
    
    maxWeight = 300.0f;
    runCounter = 0;
    databaseCreated = NO;
    _showConditions = YES;
    
    [self load];
    
    return self;
}

- (void)save{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:maxWeight] forKey:@"maxW"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: databaseCreated ? 1 : 0] forKey:@"base"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: _showConditions ? 1 : 0] forKey:@"showConditions"];
    
    //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:runCounter] forKey:@"run"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) plusRunCounter{
    runCounter++;
}

- (void) load{
    
    NSNumber * created = [[NSUserDefaults standardUserDefaults] objectForKey:@"base"];
    if (created) {
        databaseCreated = ([created intValue] == 1);
    }
    
    NSNumber * max = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxW"];
    if (max) {
        maxWeight = [max floatValue];
    }
    
    NSNumber * run = [[NSUserDefaults standardUserDefaults] objectForKey:@"run"];
    if (run) {
        runCounter = [run intValue];
    }
    
    NSNumber * cond = [[NSUserDefaults standardUserDefaults] objectForKey:@"showConditions"];
    if (cond) {
        _showConditions = ([cond intValue] == 1);
    }
}




@end
