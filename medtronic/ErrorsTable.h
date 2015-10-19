//
//  ErrorsTable.h
//  home
//
//  Created by Hanna Dutkiewicz on 12-04-24.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>

static

@interface ErrorsTable : NSObject{

    NSMutableDictionary * errorCodes;
    
}

+ (ErrorsTable *) sharedSingleton;

- (NSString *) getStringForError: (NSString *) code;


@end
