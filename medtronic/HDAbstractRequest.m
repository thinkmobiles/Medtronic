//
//  AbstractHomerRequest.m
//  homer
//
//  Created by Hanna Dutkiewicz on 11-03-17.
//  Copyright 2011 Looksoft Sp. z o. o. All rights reserved.
//

#import "HDAbstractRequest.h"
#import "HDRequestQueue.h"
#import "Utils.h"


@implementation HDAbstractRequest

@synthesize 
dataReceived,
connection,
req,
error,
counterTrying,
requestDelegate,
boundary,
newline;


- (id) init{
    self = [super init];
    dataReceived = nil;
    connection = nil;
    req = nil;
    error = nil;
    finished = NO;
    executing = NO;
    counterTrying = 0;
    cancelled = NO;
    
    boundary = @"-----------------------------";
    newline = @"\r\n";
    
    return self;
}


+ (NSString *) getMainURL{
    return @"http://medtronic.eq6.pl/";
}

- (NSString *) getPostfixURL{
    return @"";
}


- (void) execRequestWithData: (NSData *) postData{

    req = [[NSMutableURLRequest alloc] init];
    
	NSString * postL = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableString * theUrl = [NSMutableString stringWithFormat:@"%@%@", [HDAbstractRequest getMainURL], [self getPostfixURL]];
#if DEBUG
    NSLog(@"url: %@", theUrl);
#endif
	[self.req setURL:[NSURL URLWithString: theUrl]];
    
	[self.req setHTTPMethod:@"POST"];
	[self.req setTimeoutInterval:20];
    
    [self.req setValue:postL               forHTTPHeaderField:@"Content-Length"];
	[self.req setValue: [NSString stringWithFormat: @"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [self.req setHTTPBody:postData];
    
    NSString * str = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
#if DEBUG
    NSLog(@"POST: \n%@\n", str);
#endif
    [[HDRequestQueue sharedSingleton] addRequest: self];
}


- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *) space {
    if([[space authenticationMethod] 
        isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        return YES; 
    }
    return NO;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    [[challenge sender] useCredential:[NSURLCredential credentialForTrust: [[challenge protectionSpace] serverTrust] ] forAuthenticationChallenge:challenge];
}



- (BOOL) isFinished{
    return finished;
}


- (BOOL) isExecuting{
    return executing;
}


- (BOOL) isConcurrent{
    return YES;
}


- (void) cancel{
    cancelled = YES;
}


- (void) start{
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (cancelled) {
        [self finish];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    connection = [[NSURLConnection alloc] initWithRequest:self.req delegate:self];
    
    if (connection == nil) {
        [self finish];
    }
    [requestDelegate didBeginConnection];
}


- (void) finish{
    
    if (finished) {
        return;
    }
    
    connection = nil;

    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];    
    
    [requestDelegate didFinishConnection];
    
    if (cancelled) {
        dataReceived = nil;
        return;
    }
    
    
    if (dataReceived != nil && !error) {
        NSString * str = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
#if DEBUG
        NSLog(@"REC: \n%@\n", str);
#endif
        [requestDelegate didReceiveString: str];
        dataReceived = nil;
        return;
    }
    else{
        NSLog(@"REC: nil\n"); 
    }
    
    if(dataReceived == nil){
        
        if (dataReceived == nil) {
            error = @"Błąd przesyłu danych. Prawdopodobnie utracono dostęp do internetu.";
        }
        [self connectionError:error];
        
    }
	dataReceived = nil;
}
 


/********* delegate of connection *********/

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
	if (dataReceived == nil) {
		dataReceived = [[NSMutableData alloc] initWithData:data];
	}else {
		[dataReceived appendData:[NSData dataWithData:data]];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    // sprawdzenie errorow
    if (dataReceived == nil) {
        dataReceived = nil;
        error = nil;
        [self finish];
        return;
    }
    
	[self finish];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err{
	
    if ([err code] < -1000 && [err code] > -1010 ) {
        dataReceived = nil;
        error = nil;
    }else{
        error = [[NSString alloc] initWithFormat:@"%@", [err localizedDescription]];
        NSLog(@"error: %d", [err code]);
    }
    
    [self finish];
}


- (void) tryAgain{

}


- (void) connectionError: (NSString *) err{
    [requestDelegate didReceiveConnectionError: err];
}

- (NSString *) addPart: (NSString *) name value: (NSString *) value{
    
    NSMutableString * postString = [[NSMutableString alloc] init];
    
    NSString * endline = @"\r\n";
    NSString * content = @"Content-Disposition: form-data; name=";
    
    [postString appendString: [NSString stringWithFormat:@"--%@", boundary] ];
    [postString appendString:endline];
    
    [postString appendString:content];
    [postString appendFormat:@"\"%@\"", name];
    [postString appendString:endline];
    [postString appendString:endline];
    [postString appendFormat:@"%@", value];
    [postString appendString:endline];

    return postString;
}

- (NSString *)endMultipartPost{
    NSMutableString * postString = [[NSMutableString alloc] init];
    
    [postString appendString: [NSString stringWithFormat:@"--%@", boundary]];
    [postString appendString: newline];
    [postString appendString:@"Content-Disposition: form-data; name=\"save\""];
    [postString appendString: newline];
    [postString appendString: newline];
    [postString appendString: newline];
    [postString appendString: [NSString stringWithFormat:@"--%@", boundary]];
    [postString appendString: @"--"];
    [postString appendString: newline];
    
    return postString;
}


@end
