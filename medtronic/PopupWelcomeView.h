//
//  PopupWelcomeView.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-22.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupView.h"

@interface PopupWelcomeView : PopupView

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *checkButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonClicked:(id)sender;
- (IBAction)checkButtonClicked:(id)sender;

@end
