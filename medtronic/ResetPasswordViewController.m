//
//  ResetPasswordViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordRequest.h"

@implementation ResetPasswordViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.infoText setText:@"Jeśli zapomniałeś hasła do odzyskania danych, wpisz ponownie swój e-mail. Na skrzynkę zostanie przesłane nowe hasło do pobrania danych."];
    
    [[self myRealNavigationItem] setTitle:@"Nowe hasło"];
}

- (IBAction)sendButtonClicked:(id)sender{
    if ([[self.textField text] length] == 0 ) {
        [self showError:@"Wpisz e-mail przed wysłaniem."];
        return;
    }
    
    ResetPasswordRequest * req = [[ResetPasswordRequest alloc] initWithDelegate:self];
    [req execRequestWithEmail: [self.textField text]];
}

- (void)didFinishSuccessfull:(MedtronicRequest *)req{
    [self showMessage:@"Na podany adres e-mail zostanie wysłane nowe hasło do odzyskania danych."];
    [[self myRealNavigationController] popViewControllerAnimated:YES];
}


@end
