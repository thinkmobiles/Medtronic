//
//  AcceptConditionsViewController.h
//  medtronic
//
//  Created by LooksoftHD on 15.04.2014.
//  Copyright (c) 2014 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"

@interface AcceptConditionsViewController : AbstractMedtronicViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *acceptCheckboxButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (IBAction)okButtonClicked:(id)sender;
- (IBAction)checkboxClicked:(id)sender;

@end
