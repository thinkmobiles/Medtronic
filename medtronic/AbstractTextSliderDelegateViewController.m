//
//  AbstractTextFieldDelegateViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractTextSliderDelegateViewController.h"

@implementation AbstractTextSliderDelegateViewController

@synthesize
sliderDelegate, mySlider;

- (void)viewDidLoad{
    [super viewDidLoad];
    _lastTextField = nil;
    wasUp = NO;
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
}


#pragma mark text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self myTextViewDidBeginEditing: textField];
}

- (void)myTextViewDidBeginEditing:(UIView *)textField{
    if (_lastTextField == nil) {
        [self animateTextField: textField up: YES];
        
        [self.view addGestureRecognizer:tap];    
    }
    
    _lastTextField = textField;
}

- (IBAction) dismissKeyboard{
    [self.view removeGestureRecognizer:tap];
    
    if (_lastTextField != nil) {
        [self animateTextField: _lastTextField up:NO];
        [_lastTextField resignFirstResponder];
        _lastTextField = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view removeGestureRecognizer:tap];
    [textField resignFirstResponder];
    [self animateTextField: textField up:NO];
    _lastTextField = nil;
	return YES;
}

- (BOOL) canBecomeFirstResponder{
    return YES;
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}


- (void) animateTextField: (UIView *) textField up: (BOOL) up{
    
    
    float realOffset = textField.frame.origin.y+textField.frame.size.height;
    
    UIView * superV = textField.superview;
    while (superV != nil) {
        realOffset += superV.frame.origin.y;
        superV = superV.superview;
        //NSLog(@"now: %f", realOffset);
    }
    
    if (realOffset < (260)+44 && (up || (!up && !wasUp) )) {
        return;
    }
    
    if (up) {
        wasUp = YES;
    }
    
    int moveDistance = 140;
	const float moveDuration = 0.25f;
    
	int movement = (up ? -moveDistance : moveDistance);
    
    [UIView beginAnimations:@"fieldAnim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:moveDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)slidersValueChanged:(id)sender {
    
    double val = (int)(mySlider.value+0.5f);
    if (val <= 1.0f) {
        mySlider.value = 1.0f;
        val = 1.0f;
    }
    [sliderDelegate valueChanged: val];
}

- (IBAction)sliderDraggedInside:(id)sender {    
    int val = (int)(mySlider.value+0.5f);
    if (val <= 1.0f) {
        mySlider.value = 1.0f;
        val = 1.0f;
    }
    [sliderDelegate valueChanged: val];
}



@end
