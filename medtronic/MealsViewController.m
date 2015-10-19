//
//  MealsViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MealsViewController.h"

#import "ElementsListViewController.h"
#import "CategoriesViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "AddMealViewController.h"
#import "PopupWelcomeView.h"
#import "AppDelegate.h"
#import "Meal.h"
#import "DetailMealViewController.h"
#import "MedtronicConstants.h"

@implementation MealsViewController

@synthesize popsManager;

#pragma mark - View lifecycle

- (void)viewDidLoad{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    isInside = YES;
    [super viewDidLoad];
    
    [self setTitle:@"Posiłki"];
    [self addPlusButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mealWasAdded:) name:@"Meal_added" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mealWasNotAdded:) name:@"Meal_not_added" object:nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)initControllers{
  
    controllersArray = [[NSMutableArray alloc] init];
    
    [controllersArray addObject: [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: MEAL andMainFilter: ALL]] ];
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: [[CategoriesViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: MEAL]]];
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: MEAL andMainFilter: FAVOURITE]]];
}

- (void)plusButtonClicked:(id)sender{
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicFastCreateMealController" owner:nil options:nil];

    //NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddMealController" owner:nil options:nil];
    UINavigationController * navController = [arr objectAtIndex:0];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)mealWasAdded:(NSNotification *)notif{
    Meal * product = [[notif userInfo] objectForKey:@"element"];
    if (product) {
        DetailMealViewController * productView = [[DetailMealViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: product];
        productView.isInside = self.isInside;
        [[self myRealNavigationController] pushViewController: productView animated:YES];
        [self dismissViewControllerAnimated:YES completion: nil];
    }
}

- (void) mealWasNotAdded: (NSNotification *) notif{
    [self dismissViewControllerAnimated:YES completion: nil];
}

@end
