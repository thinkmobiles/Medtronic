//
//  AbstractTextFieldDelegateViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

@protocol UISliderDelegate <NSObject>

- (void) valueChanged: (double) newVal;

@end

@interface AbstractTextSliderDelegateViewController : UIViewController
<UITextViewDelegate, UITextFieldDelegate>{

//    UIView * lastTextField;
    UITapGestureRecognizer * tap;
    BOOL wasUp;
    
    id<UISliderDelegate> sliderDelgate;
}

@property (nonatomic, strong) UIView * lastTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider * mySlider;
@property (nonatomic, retain) id<UISliderDelegate> sliderDelegate;

- (void) animateTextField: (UIView *) textField up: (BOOL) up;
- (void)myTextViewDidBeginEditing:(UIView *)textField;

- (IBAction) dismissKeyboard;

- (IBAction)slidersValueChanged:(id)sender;
- (IBAction)sliderDraggedInside:(id)sender;

@end
