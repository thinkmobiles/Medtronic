//
//  Meal.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Meal.h"
#import "Utils.h"

@implementation Meal

@synthesize mealWeight;

- (MedtronicObject *) clone{
    return [[Meal alloc] init];
}

- (void) fillWithMoreInfo: (sqlite3_stmt *) details{
    [super fillWithMoreInfo: details];
    mealWeight = sqlite3_column_double(details, 17);
}

- (void) finishInitializing{
    
}

@end
