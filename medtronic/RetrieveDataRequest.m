//
//  RetrieveDataRequest.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "RetrieveDataRequest.h"
#import "Utils.h"
#import "SQLiteController.h"

@implementation RetrieveDataRequest

@synthesize password;

- (void) execRequestWithEmail: (NSString *) email{
    NSMutableString * postString = [[NSMutableString alloc] init];
    [postString appendString:newline];
    
    [postString appendString: [self addPart:@"_method" value:@"POST"]];
    [postString appendString: [self addPart:@"email" value: email] ];
    [postString appendString: [self addPart:@"uuid" value: [[[UIDevice currentDevice] identifierForVendor] UUIDString]]];
    if (password) {
        [postString appendString: [self addPart:@"pass" value: [Utils sha1: password]] ];
    }
    
    [postString appendString: [self endMultipartPost]];
    
    NSData * data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [self execRequestWithData: data];
}


- (NSString *)getPostfixURL{
    if (password) {
        return @"retrieve/login";
    }
    
    return @"retrieve";
}

- (void)otherDataReceived:(NSString *)str{
    
    NSError * nserror = nil;
    NSString * json = [NSString stringWithContentsOfURL: [NSURL URLWithString: str] encoding:NSUTF8StringEncoding error:&nserror];
    NSLog(@"REC:\n%@", json);
    
    // ok, let's parse it
    if ([[SQLiteController sharedSingleton] loadDatabase: json]) {
        [delegate didFinishSuccessfull: self];
    }
    else{
        [delegate didNotReceiveAnyData: self];
    }
}

@end
