//
//  Category.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize isUserDefined, depth, type;

- (MedtronicObject *) clone{
    return [[Category alloc] init];
}

- (id) initWithId: (int) _theid andName: (NSString *) _name{
    self = [super initWithId: _theid andName:_name];
    
    isUserDefined = YES;
    depth = 1;
    
    return self;
}

- (void)fillWithId:(int)_theid andName:(NSString *)_name moreIfNecessary:(sqlite3_stmt *)selectstmt{
    [super fillWithId:_theid andName:_name moreIfNecessary:selectstmt];
    isUserDefined = sqlite3_column_int(selectstmt, 4) == 1;
    depth = sqlite3_column_int(selectstmt, 3);
    type = sqlite3_column_int(selectstmt, 2);
}


- (void) fillWithMoreInfo: (sqlite3_stmt *) details{

    [super fillWithMoreInfo: details];
    
    isUserDefined = sqlite3_column_int(details, 4) == 1;
    depth = sqlite3_column_int(details, 3);
    type = sqlite3_column_int(details, 2);
}



@end
