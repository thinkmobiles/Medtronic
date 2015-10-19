//
//  AbstractMedtronicViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#ifndef ALL_H
#define ALL_H

#import "AbstractMedtronicViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "AbstractMedtronicExclusiveButtonsController.h"

@implementation AbstractMedtronicViewController

@synthesize previousController, myStack, myBackButton, navBar, navItem, isInside, forceNotInside, alertLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    isInside = NO;
    forceNotInside = NO;
    return self;
}

- (void)viewDidLoad{
    //NSLog(@"before Is inside? %@", isInside ? @"YES" : @"NO");
    [super viewDidLoad];
    //NSLog(@"after Is inside? %@", isInside ? @"YES" : @"NO");
    self.lastTextField = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIView * fakeStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        fakeStatusBar.backgroundColor = [UIColor blackColor];
        [self.navigationController.view addSubview: fakeStatusBar];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (forceNotInside) {
        return;
    }
    
    if (isInside && self.myStack == nil) {
        self.navBar = [[MedtronicNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        self.navItem = [[UINavigationItem alloc] initWithTitle:@""];
        
        [self.navBar pushNavigationItem:navItem animated:NO];
        [self.view addSubview: self.navBar];
        
        if (self.navigationItem) {
            [self.navItem setTitle: self.navigationItem.title];
        }
        
        UIView * lastOne = nil;
        for (UIView * sub in self.view.subviews) {
            if (sub == self.navBar) {
                continue;
            }
            
            CGRect fr = sub.frame;
            if (fr.origin.y+fr.size.height == self.view.frame.size.height) {
                fr.size.height -= (44);
            }
            fr.origin.y += (44);
            [sub setFrame: fr];
            lastOne = sub;
        }
    }
    
    if (self.navigationController.navigationBar) {

    }
    /*
    if (self.isInside) {
        CGRect wholeRect = [UIScreen mainScreen].bounds;
        CGRect myFrame = self.view.frame;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            myFrame.size.height = wholeRect.size.height-50-44-20-44;
            self.view.frame = myFrame;
        }
    */
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    if ([[self.navigationController viewControllers] count] > 1 && !myBackButton) {
        
        self.myBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * bim = [UIImage imageNamed:@"back_button.png"];
        [myBackButton setImage:bim forState:UIControlStateNormal];
        [myBackButton setImage:[UIImage imageNamed:@"back_button_s.png"] forState:UIControlStateHighlighted];
        [myBackButton setFrame: CGRectMake(0, 0, bim.size.width, bim.size.height)];
        
        UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView: myBackButton];
        [myBackButton addTarget:self action:@selector(customGoBack) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.navBar) {
            [self.navItem setLeftBarButtonItem: backButton];
        }
        else{
            [self.navigationItem setLeftBarButtonItem: backButton];
        }
        
    }
    
    else if (![self isKindOfClass:[AbstractMedtronicExclusiveButtonsController class]]) {
        
        if (myBackButton == nil && [myStack.controllersStack count] > 1) {
            myBackButton = previousController.myBackButton;
            UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView: myBackButton];
            [myBackButton addTarget:self action:@selector(customGoBack) forControlEvents:UIControlEventTouchUpInside];
            
            //NSLog(@"TITLE: %@", self.navigationItem.title);
            
            if (self.navBar) {
                [self.navItem setLeftBarButtonItem: backButton];
            }
            else{
                [self.navigationItem setLeftBarButtonItem: backButton];
            }
        }
    }
    
    /*
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        
        for (UIView * sub in self.view.subviews) {
            CGRect fr = sub.frame;
            if (fr.origin.y+fr.size.height > self.view.frame.size.height) {
                [((UIScrollView *) self.view) setContentSize:CGSizeMake(self.view.frame.size.width, fr.origin.y+fr.size.height)];
            }
        }
        
    }*/
    if (self.navigationController.navigationBar) {
        MedtronicNavigationBar * medBar = (MedtronicNavigationBar *)self.navigationController.navigationBar;
        [medBar setNeedsDisplay];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    if (self.navigationController.navigationBar) {
//        MedtronicNavigationBar * medBar = (MedtronicNavigationBar *)self.navigationController.navigationBar;
        //[medBar setMyLabel];
    }
}


- (void)setTitle:(NSString *)title{
    if (self.navBar) {
        [self.navItem setTitle: title];
    }
    else{
        [super setTitle:title];
    }
}

- (void) customGoBack{
    
    if ([[self.navigationController viewControllers] count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(myStack){
        [myStack popViewController];
    }
}


- (void) addOkButton{
    UIButton * add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
    [add setBackgroundImage: [UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
    
    [add setTitle:@"Gotowe" forState:UIControlStateNormal];
    [add.titleLabel setFont: [UIFont boldSystemFontOfSize:12]];
    [add.titleLabel setTextColor: [UIColor whiteColor]];
    
    [add setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"small_button.png"].size.width-20, [UIImage imageNamed:@"small_button.png"].size.height)];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: add];
    [add addTarget:self action:@selector(okAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[self myRealNavigationItem] setRightBarButtonItem: plus];
}


- (void) addCancelButton{
    UIButton * add = [self createNavigationBarButton:@"Anuluj"];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: add];
    [add addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.myStack){
        AbstractMedtronicViewController * c = (AbstractMedtronicViewController*)self.myStack.delegate;
        
        if (c.navBar) {
            [c.navItem setLeftBarButtonItem: plus];
        }
        else{
            [c.navigationItem setLeftBarButtonItem: plus];
        }
        
        //[c.navigationItem setRightBarButtonItem: plus];
    }
    else if (self.navigationItem) {
        [self.navigationItem setLeftBarButtonItem: plus];
    }
}

- (void)okAdd:(id)sender{}
- (void) cancel:(id)sender{}


- (void)showError:(NSString *)err{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Błąd" message:err delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (void)showMessage:(NSString *)msg{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (UINavigationItem *) myRealNavigationItem{
    
    if (self.navBar) {
        return self.navItem;
    }
    
    if(self.myStack){
        AbstractMedtronicViewController * c = (AbstractMedtronicViewController*)self.myStack.delegate;
        
        if (c.navBar) {
            return c.navItem;
        }
        else{
            return c.navigationItem;
        }
    }
    return self.navigationItem;
}

- (UINavigationController *) myRealNavigationController{
    if(self.myStack){
        AbstractMedtronicViewController * c = (AbstractMedtronicViewController*)self.myStack.delegate;
        if ([c isKindOfClass: [UINavigationController class]]) {
            return (UINavigationController *)c;
        }
        if (c.navigationController) {
            return c.navigationController;
        }
    }
    return self.navigationController;
}

- (NSString *)getCategoryLabel{
    return @"";
}

- (UIButton *)createNavigationBarButton:(NSString *)title{
    
    UIButton * add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
    [add setBackgroundImage: [UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
    
    [add setTitle: title forState:UIControlStateNormal];
    [add.titleLabel setFont: [UIFont boldSystemFontOfSize:12]];
    [add.titleLabel setTextColor: [UIColor whiteColor]];
    
    [add setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"small_button.png"].size.width-20, [UIImage imageNamed:@"small_button.png"].size.height)];

    return add;
}

#pragma mark MedtronicRequestDelegate

- (void)beginLoading{
    if (!alertLoading) {
        alertLoading = [[UIAlertView alloc] initWithTitle:@"" message:@"Wysyłanie danych..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];   
        spinner.center = CGPointMake(139.5, 75.5); // .5 so it doesn't blur
        [alertLoading addSubview:spinner];
        [spinner startAnimating];
    }
    [alertLoading show];
}

- (void)endLoading{
    [alertLoading dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) didFinishSuccessfull: (MedtronicRequest *) req{

}

- (void) didFinishUnseccessful : (MedtronicRequest *) req{

}

- (void) passwordRequired: (MedtronicRequest *) req{
}

@end

#endif
