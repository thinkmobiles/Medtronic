//
//  AppSettingsViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-18.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"

@interface AppSettingsViewController : AbstractMedtronicViewController
<NSURLConnectionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *maxWeightText;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *getButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordButton;
- (void) addBackButton;
- (IBAction)goBack:(id)sender;
- (IBAction)saveDataClicked:(id)sender;
- (IBAction)loadDataClicked:(id)sender;
- (IBAction)forgotPasswordClicked:(id)sender;




@end
