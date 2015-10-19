//
//  AbstractHomeRequest.h
//
//  Created by Hanna Dutkiewicz on 11-03-17.
//  Copyright 2011 Looksoft Sp. z o. o. All rights reserved.
//

/**
 Abstract request delegate.
*/
@protocol HDAbstractHomeRequestDelegate


- (void) didReceiveConnectionError: (NSString *) error;
- (void) didBeginConnection;
- (void) didFinishConnection;
- (void) didReceiveString: (NSString *) str;

@end


/**
 Abstract request.
*/
@interface HDAbstractRequest : NSOperation
<UIAlertViewDelegate>
{
    id<HDAbstractHomeRequestDelegate> requestDelegate;
    
	NSMutableData * dataReceived;
	NSURLConnection * connection;
	NSMutableURLRequest * req;
    NSString * error;
    
    BOOL finished;
    BOOL cancelled;
    BOOL executing;
    
    int counterTrying;
    NSString * boundary;
    NSString * newline;
}

@property (nonatomic, retain) NSString * boundary;
@property (nonatomic, retain) NSString * newline;

@property (nonatomic, retain) id<HDAbstractHomeRequestDelegate> requestDelegate;
@property (nonatomic, retain) NSMutableData * dataReceived;
@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, retain) NSMutableURLRequest * req;
@property (nonatomic, retain) NSString * error;


@property int counterTrying;

- (void) execRequestWithData: (NSData *) data;
- (void) finish;

- (void) tryAgain;
- (void) connectionError: (NSString *) error;

- (NSString *) addPart: (NSString *) name value: (NSString *) value;
- (NSString *) endMultipartPost;

+ (NSString *) getMainURL;
- (NSString *) getPostfixURL;


@end
