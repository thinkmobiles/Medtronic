//
//  RectUtils.h
//  tvpsport
//
//  Created by LooksoftHD on 02.04.2014.
//  Copyright (c) 2014 Looksoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RectUtils : NSObject


+ (CGRect) rect: (CGRect) rect offsetYSmallerHeight: (float) offY;
+ (CGRect) rect: (CGRect) rect fixedOriginYSmallerHeight: (float) offY;
+ (CGRect) rect: (CGRect) rect nextToRect: (CGRect) leftRect horizontalLayout: (NSLayoutAttribute) layout;

+ (void) logRect: (CGRect) rect withTitle: (NSString *) str;
+ (void) logRect: (CGRect) rect;

@end
