//
//  HomerRequestQueue.m
//  homer
//
//  Created by Hanna Dutkiewicz on 11-03-17.
//  Copyright 2011 Looksoft Sp. z o. o. All rights reserved.
//

#import "HDRequestQueue.h"


@implementation HDRequestQueue


@synthesize 
queue;


+ (HDRequestQueue *) sharedSingleton{
    static HDRequestQueue * singleton;
	
	@synchronized(self){
		if (!singleton) {
			singleton = [[HDRequestQueue alloc] init];
		}
		return singleton;
	}
}


- (id) init{
    self = [super init];
    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    return self;
}



- (void) addRequest: (NSOperation *) request{
    [queue addOperation: request];
}

- (void) clearAll{
    [queue cancelAllOperations];
}

@end
