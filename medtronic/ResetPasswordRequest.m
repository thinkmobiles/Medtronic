//
//  ResetPasswordRequest.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ResetPasswordRequest.h"

@implementation ResetPasswordRequest

- (void) execRequestWithEmail: (NSString *) email{
    
    NSMutableString * postString = [[NSMutableString alloc] init];
    [postString appendString:newline];
    
    [postString appendString: [self addPart:@"_method" value:@"POST"]];
    [postString appendString: [self addPart:@"email" value: email] ];
    [postString appendString: [self addPart:@"uuid" value: [[[UIDevice currentDevice] identifierForVendor] UUIDString]]];
    [postString appendString: [self endMultipartPost]];
    
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [self execRequestWithData: data];
}

- (NSString *)getPostfixURL{
    return @"reset";
}

@end
