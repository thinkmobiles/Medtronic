//
//  HomeRequest.m
//  home
//
//  Created by Hanna Dutkiewicz on 12-03-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicRequest.h"
#import "Utils.h"
#import "HDRequestQueue.h"
#import "ErrorsTable.h"
#import "Settings.h"

@implementation MedtronicRequest

@synthesize
delegate;


- (id) initWithDelegate: (id<MedtronicRequestDelegate>) del{
    
    self = [super init];
    
    delegate = del;
    requestDelegate = self;
    
    return self;
}

#pragma mark HDAbstractHomeRequestDelegate
/**
 !To overwrite.
*/


- (void) didReceiveConnectionError:(NSString *)error{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Błąd" message:@"Błąd połączenia" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}


- (void) didBeginConnection{
    [delegate beginLoading];
}

- (void) didFinishConnection{
    //NSLog(@"FINISH: %d", [[[HDRequestQueue sharedSingleton] queue] operationCount]);
    if ([[[HDRequestQueue sharedSingleton] queue] operationCount] <= 1) {
        [delegate endLoading];
    }
}

- (NSString *)getDefaultMessage{
    return @"Błąd połączenia z serwerem. Spróbuj ponownie później.";
}

- (void)didReceiveString:(NSString *)str{
    if ([str isEqualToString:@"10"]) {
        [delegate didFinishSuccessfull: self];
        return;
    }
    if ([str isEqualToString:@"11"]) {
        [delegate passwordRequired: self];
        return;
    }
    NSString * err = [[ErrorsTable sharedSingleton] getStringForError: str];
    if (!err) {
        [self otherDataReceived: str];
        
        return;
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Błąd" message: err delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [delegate didFinishUnseccessful:self];
}

- (NSString *) addUUIDto: (NSString *) str{
    
    NSString * unique = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSMutableString * mutable = [[NSMutableString alloc] initWithFormat:@"%@&uuid=%@", str, unique];
    return mutable;
}

- (void) otherDataReceived: (NSString *) str{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Błąd" message: [self getDefaultMessage] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [delegate didFinishUnseccessful:self];
}

@end
