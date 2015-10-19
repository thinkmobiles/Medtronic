//
//  AppSettingsViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-18.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AppSettingsViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "Settings.h"
#import "FoodParametres.h"
#import "Utils.h"
#import "GetBackupViewController.h"
#import "SaveBackupViewController.h"
#import "ResetPasswordViewController.h"

@implementation AppSettingsViewController
@synthesize maxWeightText;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addBackButton];
    
    [self.maxWeightText setText: [FoodParametres doubleString: [Settings sharedSingleton].maxWeight ]];
    
    UIImage * buttonIm = [[UIImage imageNamed:@"small_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode: UIImageResizingModeStretch];
    UIImage * buttonImS = [[UIImage imageNamed:@"small_button_s"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode: UIImageResizingModeStretch];
    [self.saveButton setBackgroundImage: buttonIm forState: UIControlStateNormal];
    [self.getButton setBackgroundImage: buttonIm forState: UIControlStateNormal];
    [self.passwordButton setBackgroundImage: buttonIm forState: UIControlStateNormal];

    [self.saveButton setBackgroundImage: buttonImS forState: UIControlStateHighlighted];
    [self.getButton setBackgroundImage: buttonImS forState: UIControlStateHighlighted];
    [self.passwordButton setBackgroundImage: buttonImS forState: UIControlStateHighlighted];
}


- (void) addBackButton{
    UIButton * add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setImage: [UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [add setImage: [UIImage imageNamed:@"back_button_s.png"] forState:UIControlStateHighlighted];
    
    [add setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"back_button.png"].size.width, [UIImage imageNamed:@"back_button.png"].size.height)];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: add];
    [add addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [[self myRealNavigationItem] setLeftBarButtonItem: plus];
}

- (IBAction)goBack:(id)sender{
    [(UIViewController*)self.myStack.delegate dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)saveDataClicked:(id)sender {
    SaveBackupViewController * nextView = [[SaveBackupViewController alloc] initWithNibName:@"AbstractBackupViewController" bundle:nil];
    nextView.previousController = self;
    [[self myRealNavigationController] pushViewController:nextView animated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    NSLog(@"Fail");
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
}

- (IBAction)loadDataClicked:(id)sender {
    GetBackupViewController * nextView = [[GetBackupViewController alloc] initWithNibName:@"GetBackupViewController" bundle:nil];
    nextView.previousController = self;
    [[self myRealNavigationController] pushViewController: nextView animated:YES];
}

- (IBAction)forgotPasswordClicked:(id)sender {
    ResetPasswordViewController * nextView = [[ResetPasswordViewController alloc] initWithNibName:@"AbstractBackupViewController" bundle:nil];
    [[self myRealNavigationController] pushViewController:nextView animated:YES];
}

- (void)viewDidUnload {
    [self setMaxWeightText:nil];
    [super viewDidUnload];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    float value = [textField.text intValue];
    if (value < 50.0f) {
        value = 50.0f;
    }
    if (value > 3000.0f) {
        value = 3000.0f;
    }
    [textField setText: [FoodParametres doubleString: value]];
    [Settings sharedSingleton].maxWeight = value;
}

@end
