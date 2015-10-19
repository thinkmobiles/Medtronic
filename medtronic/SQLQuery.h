//
//  SQLQuery.h
//  medtronic
//
//  Created by Apple Saturn on 12-09-07.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLQuery : NSObject


+ (NSString *) sqlRemoveElement: (int) theid;
+ (NSString *) sqlRemoveCategory: (int) theid;


@end
