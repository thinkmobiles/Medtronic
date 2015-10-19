//
//  PasswordRequiredViewController.m
//  medtronic
//
//  Created by Apple Saturn on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "PasswordRequiredViewController.h"
#import "SaveDataRequest.h"
#import "RetrieveDataRequest.h"

@implementation PasswordRequiredViewController

@synthesize email, db;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (db) {
        [[self myRealNavigationItem] setTitle:@"Zapis danych"];
    }
    else{
        [[self myRealNavigationItem] setTitle:@"Odzyskiwanie"];
        [self.infoText setText:@"Dane użytkownika zostały zapisane z innego telefonu. W celu weryfikacji wpisz hasło otrzymane w e-mailu."];
    }
    
}

- (IBAction)sendButtonClicked:(id)sender{
    if ([[self.textField text] length] == 0 ) {
        [self showError:@"Wpisz hasło przed wysłaniem."];
        return;
    }
    
    if (db) {
        SaveDataRequest * req = [[SaveDataRequest alloc] initWithDelegate:self];
        req.password = [self.textField text];
        [req execRequestWithEmail: email andDbText:db];
    }
    else{
        RetrieveDataRequest * req = [[RetrieveDataRequest alloc] initWithDelegate:self];
        req.password = [self.textField text];
        [req execRequestWithEmail: email];
    }
    
}

- (void)didFinishSuccessfull:(MedtronicRequest *)req{
    
    if (db) {
        [self showMessage:@"Dane zostały zapisane na serwerze."];
    }
    else{
        [self showMessage:@"Dane aplikacji zostały pobrane z serwera."];
    }
    
    [[self myRealNavigationController] popToRootViewControllerAnimated:YES];
}



@end
