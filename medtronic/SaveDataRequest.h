//
//  SaveDataRequest.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicRequest.h"

@interface SaveDataRequest : MedtronicRequest{
    NSString * password;
}

@property (nonatomic, retain) NSString * password;

- (void) execRequestWithEmail: (NSString *) email andDbText: (NSString *) db;

@end
