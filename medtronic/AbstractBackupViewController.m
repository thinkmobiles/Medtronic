//
//  AbstractBackupViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractBackupViewController.h"

@implementation AbstractBackupViewController
@synthesize textField;
@synthesize textFieldLabel;
@synthesize infoText;




#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // add "send" button
    UIButton * sendButton = [self createNavigationBarButton:@"Wyślij"];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: sendButton];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.navItem) {
        [self.navItem setRightBarButtonItem: plus];
    }
    else{
        [self.navigationItem setRightBarButtonItem: plus];
    }
}

- (void)viewDidUnload{
    [self setTextField:nil];
    [self setTextFieldLabel:nil];
    [self setInfoText:nil];
    [super viewDidUnload];
}

- (void)sendButtonClicked:(id)sender{
    
}



@end
