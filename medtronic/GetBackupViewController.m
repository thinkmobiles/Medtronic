//
//  GetBackupViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "GetBackupViewController.h"
#import "RetrieveDataRequest.h"
#import "PasswordRequiredViewController.h"

@implementation GetBackupViewController


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [[self myRealNavigationItem] setTitle:@"Odzyskiwanie"];
}

- (IBAction)sendButtonClicked:(id)sender{
    if ([[self.textField text] length] == 0 ) {
        [self showError:@"Wpisz email przed wysłaniem."];
        return;
    }
    
    RetrieveDataRequest * req = [[RetrieveDataRequest alloc] initWithDelegate:self];
    [req execRequestWithEmail: [self.textField text]];
}

- (void)passwordRequired:(MedtronicRequest *)req{
    PasswordRequiredViewController * next = [[PasswordRequiredViewController alloc] initWithNibName:@"PasswordRequiredViewController" bundle:nil];
    next.db = nil;
    next.email = [self.textField text];
    next.previousController = self.previousController;
    [[self myRealNavigationController] pushViewController:next animated:YES];
}

- (void)didFinishSuccessfull:(MedtronicRequest *)req{
    [self showMessage:@"Dane aplikacji zostały pobrane z serwera."];
    
    [[self myRealNavigationController] popToRootViewControllerAnimated:YES];
}

- (void)beginLoading{
    [super beginLoading];
    [alertLoading setMessage:@"Pobieranie danych..."];
}

@end
