//
//  ButtonView.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-18.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

@synthesize text, file, buttonsViews;

- (id)initWithJson:(NSDictionary *)dict{
    self = [super init];
    
    text = [[dict objectForKey:@"text"] copy];
    buttonsViews = [[NSMutableArray alloc] init];
    
    if ([dict objectForKey: @"views"]) {
        
        NSArray * arr = [dict objectForKey:@"views"];
        for (NSDictionary * newDict in arr) {
            
            ButtonView * recourse = [[ButtonView alloc] initWithJson:newDict];
            [buttonsViews addObject: recourse];
        }
    }
    else{
        file = [dict objectForKey:@"file"] != nil ? [[dict objectForKey:@"file"] copy] : nil;
    }
    
    return self;
}



@end
