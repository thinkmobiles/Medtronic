//
//  PopupTutorial.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-23.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "PopupView.h"

@interface PopupTutorial : PopupView

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *nextButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

- (IBAction)nextButtonClicked:(id)sender;
- (void) setAppropriateImage: (NSString *) str;


@end
