//
//  ButtonView.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-18.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ButtonView : NSObject{

    NSString * text;
    NSString * file;
    NSMutableArray * buttonsViews;

}

- (id) initWithJson: (NSDictionary *) dict;

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSMutableArray * buttonsViews;

@end
