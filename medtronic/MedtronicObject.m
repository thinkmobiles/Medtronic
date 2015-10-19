//
//  MedtronicObject.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicObject.h"


@implementation MedtronicObject

@synthesize
name,theid;

- (id) initWithId: (int) _theid andName: (NSString *) _name{
    self = [super init];
    
    theid = _theid;
    name = [_name copy];
    
    return self;
}

- (void) fillWithId: (int) _theid andName: (NSString *) _name moreIfNecessary: (sqlite3_stmt*) selectstmt{
    theid = _theid;
    name = _name;
}

- (MedtronicObject *) clone{
    return [[MedtronicObject alloc] init];
}

- (void) fillWithMoreInfo: (sqlite3_stmt *) details{
}


@end
