//
//  PopupTutorial.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-23.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "PopupTutorial.h"

@implementation PopupTutorial
@synthesize nextButton;
@synthesize imageView;
@synthesize mainView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PopupTutorial" owner:self options:nil];
        
        [self addSubview: mainView];
    }
    return self;
}

- (void) setAppropriateImage: (NSString *) str{
    [self.imageView setImage: [UIImage imageNamed:str]];
}

- (IBAction)nextButtonClicked:(id)sender {
    
    [delegate popupViewFinished: self];
}

@end
