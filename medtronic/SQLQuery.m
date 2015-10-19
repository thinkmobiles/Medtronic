//
//  SQLQuery.m
//  medtronic
//
//  Created by Apple Saturn on 12-09-07.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "SQLQuery.h"

@implementation SQLQuery

+ (NSString *) sqlRemoveElement: (int) theid{
    NSString * str = [NSString stringWithFormat:@"DELETE FROM element_has_category WHERE id_element=%d; DELETE FROM element_has_element WHERE id_parent=%d; DELETE FROM element WHERE id=%d;", theid, theid, theid];
    return str;
}

+ (NSString *) sqlRemoveCategory: (int) theid{
    NSString * str = [NSString stringWithFormat:@"DELETE FROM category_has_category WHERE id_child=%d; DELETE FROM category WHERE id=%d;", theid, theid];
    return str;
}

@end
