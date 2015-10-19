//
//  HomerRequestQueue.h
//  homer
//
//  Created by Hanna Dutkiewicz on 11-03-17.
//  Copyright 2011 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Queue with requests.
*/
@interface HDRequestQueue : NSObject {
    
    NSOperationQueue * queue;
}

@property (nonatomic, retain) NSOperationQueue * queue;


+ (HDRequestQueue *) sharedSingleton;

- (id) init;
- (void) addRequest: (NSOperation *) request;
- (void) clearAll;

@end
