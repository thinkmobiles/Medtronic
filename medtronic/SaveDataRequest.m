//
//  SaveDataRequest.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "SaveDataRequest.h"
#import "Utils.h"

@implementation SaveDataRequest

@synthesize password;

- (void) execRequestWithEmail: (NSString *) email andDbText: (NSString *) db{
    NSMutableString * postString = [[NSMutableString alloc] init];
    [postString appendString:newline];
    
    [postString appendString: [self addPart:@"_method" value:@"POST"]];
    [postString appendString: [self addPart:@"email" value: email] ];
    [postString appendString: [self addPart:@"uuid" value: [[[UIDevice currentDevice] identifierForVendor] UUIDString]]];
    if (password) {
        [postString appendString: [self addPart:@"pass" value: [Utils sha1: password]] ];
    }
    
    // let's add db
    
    [postString appendString: [NSString stringWithFormat:@"--%@", boundary] ];
    [postString appendString: newline];
    
    [postString appendString: @"Content-Disposition: file; filename=file"];
    [postString appendString: newline];
    [postString appendString: @"Content-Type: text/plain"];
    [postString appendString: newline];
    [postString appendString: newline];
    
    [postString appendString: db];
    [postString appendString: newline];
    
    [postString appendString: [self endMultipartPost]];
    
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [self execRequestWithData: data];
}


- (NSString *)getPostfixURL{
    if (password) {
        return @"save/login";
    }
    
    return @"save";
}

@end
