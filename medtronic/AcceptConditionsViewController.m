//
//  AcceptConditionsViewController.m
//  medtronic
//
//  Created by LooksoftHD on 15.04.2014.
//  Copyright (c) 2014 Looksoft Sp. z o. o. All rights reserved.
//

#import "AcceptConditionsViewController.h"
#import "Settings.h"

@interface AcceptConditionsViewController ()

@end

@implementation AcceptConditionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource: @"Warunki" ofType:@"html"];
    NSError * error = nil;
    
//    NSLog(@"file: %@", filePath);
    
    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: &error];
    
    [self.webView loadHTMLString: str baseURL:baseURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
        [Settings sharedSingleton].showConditions = NO;
        [[Settings sharedSingleton] save];
    }];
}

- (IBAction)checkboxClicked:(id)sender {
    self.acceptCheckboxButton.selected = !self.acceptCheckboxButton.selected;
    self.okButton.enabled = self.acceptCheckboxButton.selected;
}
@end
