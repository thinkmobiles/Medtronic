//
//  PopupWelcomeView.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-22.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "PopupWelcomeView.h"
#import "Utils.h"

@implementation PopupWelcomeView
@synthesize mainView;
@synthesize checkButton;
@synthesize nextButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PopupWelcomeView" owner:self options:nil];
        
        [self addSubview: mainView];
    }
    return self;
}

- (IBAction)nextButtonClicked:(id)sender {
    
    if (![checkButton isSelected]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Uwaga!" message:@"Aby korzystać z aplikacji musisz zaakceptować warunki jej użytkowania." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [delegate popupViewFinished: self];
}

- (IBAction)checkButtonClicked:(id)sender {
    [checkButton setSelected: ![checkButton isSelected]];
}

@end
