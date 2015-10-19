//
//  SaveBackupViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "SaveBackupViewController.h"
#import "SaveDataRequest.h"
#import "SQLiteController.h"
#import "PasswordRequiredViewController.h"

@implementation SaveBackupViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self myRealNavigationItem] setTitle:@"Zapis danych"];
}

- (IBAction)sendButtonClicked:(id)sender{
    if ([[self.textField text] length] == 0 ) {
        [self showError:@"Wpisz e-mail przed wysłaniem."];
        return;
    }
    
    db = [[SQLiteController sharedSingleton] serializeDatabase];
    
    SaveDataRequest * req = [[SaveDataRequest alloc] initWithDelegate:self];
    [req execRequestWithEmail: [self.textField text] andDbText: db];
}

- (void)didFinishSuccessfull:(MedtronicRequest *)req{
    [self showMessage:@"Dane zostały zapisane na serwerze."];
    [[self myRealNavigationController] popViewControllerAnimated:YES];
}

- (void)passwordRequired:(MedtronicRequest *)req{
    PasswordRequiredViewController * next = [[PasswordRequiredViewController alloc] initWithNibName:@"PasswordRequiredViewController" bundle:nil];
    next.db = db;
    next.email = [self.textField text];
    next.previousController = self.previousController;
    [[self myRealNavigationController] pushViewController:next animated:YES];
}

@end
