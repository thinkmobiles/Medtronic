//
//  Element.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Element.h"

@implementation Element

@synthesize wm,ww,fat,wbt,kcal,type,carbs,fiber,imgName,protein,wbt_proc,isFavourite,isUserDefined;


- (id) initWithId: (int) _theid andName: (NSString *) _name{
    self = [super initWithId: _theid andName:_name];
    
    fat = 0.0f;
    fiber = 0.0f;
    carbs = 0.0f;
    kcal = 0.0f;
    protein = 0.0f;
    ww = 0.0f;
    wbt = 0.0f;
    wbt_proc = 0.0f;
    wm = 0.0f;
    
    return self;
}

- (MedtronicObject *) clone{
    return [[Element alloc] init];
}

- (void) fillWithId: (int) _theid andName: (NSString *) _name moreIfNecessary: (sqlite3_stmt*) selectstmt{
    theid = _theid;
    name = _name;
    isUserDefined = sqlite3_column_int(selectstmt, 2) == 1;
}

- (void) fillWithMoreInfo: (sqlite3_stmt *) details{
 
    fat = sqlite3_column_double(details, 2);
    fiber = sqlite3_column_double(details, 3);
    carbs = sqlite3_column_double(details, 4);
    kcal = sqlite3_column_double(details, 5);
    
    //NSLog(@"kcal: %f", kcal);
    
    protein = sqlite3_column_double(details, 6);
    ww = sqlite3_column_double(details, 7);
    wbt = sqlite3_column_double(details, 8);
    wm = sqlite3_column_double(details, 9);
    wbt_proc = sqlite3_column_double(details, 10);
    type = sqlite3_column_int(details, 11);
    isFavourite = sqlite3_column_int(details, 12) == 1;
    isUserDefined = sqlite3_column_int(details, 14) == 1;
    
    NSLog(@"create kcal: %f", kcal);
}



@end
