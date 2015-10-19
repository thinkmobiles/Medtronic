//
//  AbstractMedtronicExclusiveButtonsController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicExclusiveButtonsController.h"
#import "RectUtils.h"

@implementation AbstractMedtronicExclusiveButtonsController
@synthesize subView;
@synthesize parentCategoryLabel, selectedController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    buttonsArray = [[NSMutableArray alloc] init];
    [buttonsArray addObject: [self.view viewWithTag:10]];
    [buttonsArray addObject: [self.view viewWithTag:11]];
    [buttonsArray addObject: [self.view viewWithTag:12]];
    
    [self initControllers];
    
    selectedController = [controllersArray objectAtIndex:0];
    selectedIndex = 0;
    selectedView = selectedController.currentController;
    
    for (AbstractMedtronicStackViewController * contr in controllersArray) {
        
        //[self.subView setFrame: CGRectMake(0, self.subView.frame.origin.y, self.subView.frame.size.width, 310)];
        //[contr.currentController.view setFrame:CGRectMake(0, 0, self.subView.frame.size.width, self.subView.frame.size.height)];
        contr.delegate = self;
        contr.currentController.isInside = isInside;
        
        if (contr == selectedController) {
            [self.subView addSubview: contr.currentController.view];
        }
    }
    
    [RectUtils logRect: self.subView.frame withTitle: @"sub frame"];
    [RectUtils logRect: self.view.frame withTitle: @"main frame"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    if (selectedController) {
        [selectedController.currentController viewWillAppear: animated];
    }
    
    [self.navigationItem setTitle: self.navigationController.title];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (selectedController) {
        [selectedController.currentController viewWillDisappear: animated];
    }
}

- (void) initControllers{
    controllersArray = [[NSMutableArray alloc] init];
    [controllersArray addObject: [[AbstractMedtronicViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" bundle:nil]];
    [controllersArray addObject: [[AbstractMedtronicViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" bundle:nil]];
    [controllersArray addObject: [[AbstractMedtronicViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" bundle:nil]];
}

- (IBAction)exclusiveButtonClicked:(id)sender {

    int indexToSelect = ((UIButton*) sender).tag-10;
    if (indexToSelect == selectedIndex) {
        return;
    }
    [selectedController.currentController viewWillDisappear:NO];
    [selectedController.currentController.view removeFromSuperview];
    
    // set new one
    selectedIndex = indexToSelect;
    AbstractMedtronicStackViewController * newOne = [controllersArray objectAtIndex:indexToSelect];
    
    selectedController = newOne;
    selectedView = selectedController.currentController;
    
    [self.subView addSubview: selectedView.view];
    [newOne.currentController viewWillAppear: YES];
    
    for (UIButton * but in buttonsArray) {
        [but setSelected: but == sender];
    }
    
    if ([selectedController.controllersStack count] == 1 && [[self.navigationController viewControllers] count] == 1) {
        if (self.navItem) {
            [self.navItem setLeftBarButtonItem: nil];
        }
        else{
            [self.navigationItem setLeftBarButtonItem: nil];
        }    
    }
    else {
        
        if (!myBackButton) {
            self.myBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage * bim = [UIImage imageNamed:@"back_button.png"];
            [myBackButton setImage:bim forState:UIControlStateNormal];
            [myBackButton setImage:[UIImage imageNamed:@"back_button_s.png"] forState:UIControlStateHighlighted];
            [myBackButton setFrame: CGRectMake(0, 0, bim.size.width, bim.size.height)];
        }
        UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView: myBackButton];
        [myBackButton addTarget:self action:@selector(customGoBack) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.navItem) {
             [self.navItem setLeftBarButtonItem: backButton];
        }
        else{
             [self.navigationItem setLeftBarButtonItem: backButton];
        }
    }
    
    [self.parentCategoryLabel setText: [selectedView getCategoryLabel]];
}


#pragma mark MedtronicStackViewControllerDelegate
- (void) viewChangedInController:(AbstractMedtronicStackViewController *)navController{
    
    if (navController == selectedController) {
        
        //NSLog(@"TAK");
        [selectedView viewWillDisappear:NO];
        [selectedView.view removeFromSuperview];
        
        [self.subView addSubview: selectedController.currentController.view];

        [selectedController.currentController viewWillAppear:NO];
        selectedView = selectedController.currentController;
    }
    
    if ([selectedController.controllersStack count] == 1 && [[self.navigationController viewControllers] count] == 1) {
        [[self myRealNavigationItem] setLeftBarButtonItem:nil]; 
    }
    else{// ([selectedController.controllersStack count] > 1) {
        
        if (!myBackButton) {
            self.myBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage * bim = [UIImage imageNamed:@"back_button.png"];
            [myBackButton setImage:bim forState:UIControlStateNormal];
            [myBackButton setImage:[UIImage imageNamed:@"back_button_s.png"] forState:UIControlStateHighlighted];
            [myBackButton setFrame: CGRectMake(0, 0, bim.size.width, bim.size.height)];
        }
        UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithCustomView: myBackButton];
        [myBackButton addTarget:self action:@selector(customGoBack) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.navItem) {
            [self.navItem setLeftBarButtonItem: backButton];
        }
        else{
            [self.navigationItem setLeftBarButtonItem: backButton];
        }
    }
    /*else{
        if (self.navItem) {
            [self.navItem setLeftBarButtonItem: nil];
        }
        else{
            [self.navigationItem setLeftBarButtonItem: nil];
        }    
    }*/
    
    selectedView.forceNotInside = forceNotInside;
    selectedView.isInside = isInside;
    
    [self.parentCategoryLabel setText: [selectedView getCategoryLabel]];
}

- (void) pushControllerAbove: (AbstractMedtronicViewController *) aboveOne withPrevious:(AbstractMedtronicViewController *)prev{
    
    aboveOne.previousController = prev;
    
    [self.navigationController pushViewController:aboveOne animated:YES];
    
    aboveOne.view.frame = selectedController.currentController.view.frame;
    
    [RectUtils logRect: self.view.frame withTitle: @"me"];
    [RectUtils logRect: aboveOne.view.frame withTitle:@"above"];
    [RectUtils logRect: prev.view.frame withTitle:@"prev"];
    
    aboveOne.forceNotInside = forceNotInside;
    aboveOne.isInside = isInside;
    //[self.navigationController setTitle: [aboveOne getTitleToShow]];
}

- (void)popControllerAbove{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addPlusButton{
    plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
    
    [plusButton setTitle:@"Oblicz" forState:UIControlStateNormal];
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
    if ([selectedController.controllersStack count] > 1) {
        [selectedController popViewController];
    }
    else{
        [super customGoBack];
    }
}


- (void)viewDidUnload {
    [self setParentCategoryLabel:nil];
    [super viewDidUnload];
}
@end
