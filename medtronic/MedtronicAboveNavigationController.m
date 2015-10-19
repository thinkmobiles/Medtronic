//
//  MedtronicAboveNavigationController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicAboveNavigationController.h"

@implementation MedtronicAboveNavigationController

@synthesize
rootView;

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    stackController = [[AbstractMedtronicStackViewController alloc] initWitRootController:rootView];
    
    selectedView = stackController.currentController;
    stackController.delegate = self;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view addSubview: selectedView.view];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    if (selectedView) {
        [selectedView viewWillAppear: animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (selectedView) {
        [selectedView viewWillDisappear: animated];
    }
}



#pragma mark MedtronicStackViewControllerDelegate
- (void) viewChangedInController:(AbstractMedtronicStackViewController *)navController{
    
    if (navController == stackController) {
        
        [selectedView viewWillDisappear:NO];
        [selectedView.view removeFromSuperview];
        
        [self.view addSubview: stackController.currentController.view];
        
        [stackController.currentController viewWillAppear:NO];
        selectedView = stackController.currentController;
    }
    
    if ([stackController.controllersStack count] > 1) {
        
        if (!myBackButton) {
            self.myBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage * bim = [UIImage imageNamed:@"back_button.png"];
            [myBackButton setImage:bim forState:UIControlStateNormal];
            [myBackButton setImage:[UIImage imageNamed:@"back_button_s.png"] forState:UIControlStateHighlighted];
            [myBackButton setFrame: CGRectMake(0, 0, bim.size.width, bim.size.height)];
        }
        UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView: myBackButton];
        [myBackButton addTarget:self action:@selector(customGoBack) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setLeftBarButtonItem: backButton];
    }
    else{
        
        if ([[self.navigationController viewControllers] count] > 1) {
            return;
        }
        
        [self.navigationItem setLeftBarButtonItem: nil];
    }
}

- (void) pushControllerAbove: (AbstractMedtronicViewController *) aboveOne withPrevious:(AbstractMedtronicViewController *)prev{
    
    aboveOne.previousController = prev;
    [self.navigationController pushViewController:aboveOne animated:YES];
}

- (void) popControllerAbove{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addPlusButton{
    UIButton * plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
    
    [plusButton setTitle:@"Dodaj" forState:UIControlStateNormal];
    [plusButton.titleLabel setFont: [UIFont boldSystemFontOfSize:12]];
    [plusButton.titleLabel setTextColor: [UIColor whiteColor]];
    
    [plusButton setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"small_button.png"].size.width, [UIImage imageNamed:@"small_button.png"].size.height)];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: plusButton];
    [plusButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.navItem) {
        [self.navItem setRightBarButtonItem: plus];
    }
    else{
        [self.navigationItem setRightBarButtonItem: plus];
    }
}

- (IBAction) plusButtonClicked:(id)sender{
    
}

- (void)customGoBack{
    if ([stackController.controllersStack count] > 1) {
        [stackController popViewController];
    }
    else{
        [super customGoBack];
    }
}

@end
