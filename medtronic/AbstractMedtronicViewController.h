//
//  AbstractMedtronicViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTextSliderDelegateViewController.h"
#import "MedtronicNavigationBar.h"
#import "MedtronicRequest.h"

@class AbstractMedtronicStackViewController;

@interface AbstractMedtronicViewController : AbstractTextSliderDelegateViewController
<MedtronicRequestDelegate>{

    AbstractMedtronicViewController * previousController;
    AbstractMedtronicStackViewController * myStack;
    
    UIButton * myBackButton;
    
    BOOL isInside;
    BOOL forceNotInside;
    
    UIAlertView * alertLoading;
}

@property (nonatomic, retain) UIAlertView * alertLoading;

@property BOOL isInside;
@property BOOL forceNotInside;

@property (nonatomic, retain) MedtronicNavigationBar * navBar;
@property (nonatomic, retain) UINavigationItem * navItem;

@property (nonatomic, retain) UIButton * myBackButton;

@property (nonatomic, retain) AbstractMedtronicViewController * previousController;
@property (nonatomic, retain) AbstractMedtronicStackViewController * myStack;

- (IBAction) customGoBack;

- (IBAction)okAdd:(id)sender;
- (IBAction)cancel:(id)sender;

- (NSString *) getCategoryLabel;

- (void) addOkButton;
- (void) addCancelButton;
- (UIButton *) createNavigationBarButton: (NSString *) title;

- (void) showMessage: (NSString *) msg;
- (void) showError: (NSString *) err;

- (UINavigationItem *) myRealNavigationItem;
- (UINavigationController *) myRealNavigationController;

@end
