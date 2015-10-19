//
//  UITextField+LeftMargin.m
//  tvpsport
//
//  Created by LooksoftHD on 28.03.2014.
//  Copyright (c) 2014 Looksoft. All rights reserved.
//

#import "UITextFieldLeftMargin.h"

@implementation UITextFieldLeftMargin

static CGFloat leftMargin = 10;

- (CGRect)textRectForBounds:(CGRect)bounds{
    bounds.origin.x += leftMargin;
    bounds.size.width -= leftMargin;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    bounds.origin.x += leftMargin;
    bounds.size.width -= leftMargin;
    return bounds;
}

@end
