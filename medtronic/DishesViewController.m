//
//  DishesViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "DishesViewController.h"
#import "ElementsListViewController.h"
#import "CategoriesViewController.h"
#import "AddDishViewController.h"
#import "Dish.h"
#import "DetailDishViewController.h"
#import "FastCreateAddIngredientsDishViewController.h"
#import "MedtronicConstants.h"

@implementation DishesViewController


@synthesize showMineModal;

#pragma mark - View lifecycle

- (void)viewDidLoad{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    isInside = YES;
     showMineModal = NO;
    [super viewDidLoad];
    [self setTitle:@"Potrawy"];
    [self addPlusButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishWasNotAdded:) name:@"Dish_not_added" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishWasAdded:) name:@"Dish_added" object:nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    //UIImage * im = [UIImage imageNamed: @"logo.png"];
    //self.navigationController.view.frame = CGRectMake(0.0, im.size.height, 320.0, 480.0-50-im.size.height); 
    //self.navigationController.navigationBar.frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
}

- (void)initControllers{
    
    controllersArray = [[NSMutableArray alloc] init];
    
    [controllersArray addObject: [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: DISH andMainFilter: ALL]] ];
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: [[CategoriesViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: DISH]]];
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: DISH andMainFilter: FAVOURITE]]];
}

- (void)plusButtonClicked:(id)sender{
    //NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddDishController" owner:nil options:nil];
    showMineModal = YES;
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicFastCreateDishController" owner:nil options:nil];
    UINavigationController * navController = [arr objectAtIndex:0];
    
    [[self myRealNavigationController] presentViewController: navController animated: YES completion:nil];
    
    if ([[navController.viewControllers objectAtIndex:0] isKindOfClass: [FastCreateAddIngredientsDishViewController class]]) {
        ((FastCreateAddIngredientsDishViewController *)[navController.viewControllers objectAtIndex:0]).addDishDelegate = self;
    }
}

- (void) dishWasAdded: (NSNotification *) notif{
    
    if (!showMineModal) {
        return;
    }
    showMineModal = NO;
    
    Dish * product = [[notif userInfo] objectForKey:@"element"];
    if (product) {
        NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", product.theid];
        product = (Dish*)[[SQLiteController sharedSingleton] execSelect:sel fillObject: product];
        
        AbstractMedtronicViewController * next = nil;
        
        if (product.weightCooked == 0) {
            next = [[DetailDishViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: product];
        }
        else{
            next = [[DetailDishViewController alloc] initWithNibName:@"DetailDishViewController" andObject: product];
        }
        next.isInside = self.isInside;
        [[self myRealNavigationController] pushViewController: next animated:YES];
    }
}

- (void) dishWasNotAdded: (NSNotification *) notif{
    [self dismissViewControllerAnimated:YES completion: nil];
}

@end
