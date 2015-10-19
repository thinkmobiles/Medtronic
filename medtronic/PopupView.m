//
//  PopupView.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-23.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

@synthesize delegate,
indexOfPopup;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        indexOfPopup = -1;
        [self setBackgroundColor: [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.7f]];
    }
    return self;
}


@end
