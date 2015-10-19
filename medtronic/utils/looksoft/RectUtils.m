//
//  RectUtils.m
//  tvpsport
//
//  Created by LooksoftHD on 02.04.2014.
//  Copyright (c) 2014 Looksoft. All rights reserved.
//

#import "RectUtils.h"

@implementation RectUtils

+ (CGRect) rect: (CGRect) rect offsetYSmallerHeight: (float) offY{
    return CGRectMake(rect.origin.x, rect.origin.y+offY, rect.size.width, rect.size.height-offY);
}

+ (CGRect) rect: (CGRect) rect fixedOriginYSmallerHeight: (float) offY{
    return CGRectMake(rect.origin.x, offY, rect.size.width, rect.size.height+rect.origin.y-offY);
}

+ (CGRect) rect: (CGRect) rect nextToRect: (CGRect) leftRect horizontalLayout: (NSLayoutAttribute) layout{
    switch (layout) {
        case NSLayoutAttributeBottom:
            return CGRectMake(CGRectGetMaxX(leftRect), CGRectGetMaxY(leftRect)-rect.size.height, rect.size.width, rect.size.height);
            break;
            
        case NSLayoutAttributeCenterY:
            return CGRectMake(CGRectGetMaxX(leftRect), CGRectGetMidY(leftRect)-rect.size.height/2, rect.size.width, rect.size.height);
            break;
            
        case NSLayoutAttributeTop:
            return CGRectMake(CGRectGetMaxX(leftRect), leftRect.origin.y, rect.size.width, rect.size.height);
            break;
            
        default:
            break;
    }
    return CGRectMake(CGRectGetMaxX(leftRect), rect.origin.y, rect.size.width, rect.size.height);
}

+ (void)logRect:(CGRect)rect withTitle:(NSString *)str{
#if DEBUG
    NSLog(@"%@: x:%f y:%f w:%f h:%f", str, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
#endif
}

+ (void)logRect:(CGRect)rect{
    [RectUtils logRect: rect withTitle: @"rect"];
}

@end
