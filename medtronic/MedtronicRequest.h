//
//  MedtronicRequest.h
//  home
//
//  Created by Hanna Dutkiewicz on 12-03-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//
#import "HDAbstractRequest.h"

@class MedtronicRequest;

/**
 Requests delegate.
*/
@protocol MedtronicRequestDelegate <NSObject>

- (void) beginLoading;
- (IBAction) endLoading;

@optional
// real error to show
- (void) didFinishSuccessfull: (MedtronicRequest *) req;
- (void) didFinishUnseccessful : (MedtronicRequest *) req;
- (void) didNotReceiveAnyData: (MedtronicRequest *) req;
- (void) passwordRequired: (MedtronicRequest *) req;

@end

/**
 Abstract request for all requests in project.
*/
@interface MedtronicRequest: HDAbstractRequest <HDAbstractHomeRequestDelegate>{
    id<MedtronicRequestDelegate> delegate;
    
    NSDictionary * inputParamsAfterAllow;
    NSString * commandAfterAllow;
}

@property (nonatomic, retain) id<MedtronicRequestDelegate> delegate;

- (id) initWithDelegate: (id<MedtronicRequestDelegate>) del;
- (NSString *) getDefaultMessage;
- (NSString *) addUUIDto: (NSString *) str;
- (void) otherDataReceived: (NSString *) str;

@end



