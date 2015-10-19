//
//  MedtronicNavigationBar.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicNavigationBar.h"

@implementation MedtronicNavigationBar


- (void) drawRect:(CGRect)rect{
    
    //if (!setLabel) {
        
        UIFont* titleFont = [UIFont boldSystemFontOfSize:16];
        CGSize requestedTitleSize = [self.topItem.title sizeWithFont:titleFont]; 
        CGFloat titleWidth = MIN(self.frame.size.width, requestedTitleSize.width);
        
        setLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-titleWidth)/2,0,titleWidth,45)];
        setLabel.textColor = [UIColor whiteColor];
        setLabel.backgroundColor=[UIColor clearColor];
        setLabel.font = [UIFont boldSystemFontOfSize:16];
        [setLabel adjustsFontSizeToFitWidth];
        [setLabel setTextAlignment:UITextAlignmentCenter];
        
        [setLabel setText: self.topItem.title];
        self.topItem.titleView = setLabel;
    //}
    
    //[self setTintColor: [UIColor colorWithRed:0.0f green:95.0f/255.0f blue:160.0f/255.0f alpha:1.0f]];
    
    //[super drawRect:rect];
    
    UIImage * im = [UIImage imageNamed:@"tob_bar.png"];
    [im drawInRect:rect];
}


@end
