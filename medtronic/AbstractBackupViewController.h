//
//  AbstractBackupViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractMedtronicViewController.h"

@interface AbstractBackupViewController : AbstractMedtronicViewController



@property (unsafe_unretained, nonatomic) IBOutlet UITextField *textField;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *textFieldLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *infoText;


- (IBAction) sendButtonClicked :(id)sender;

@end
