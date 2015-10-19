//
//  MealIngredientsViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MealIngredientsViewController.h"
#import "ElementsListViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "AddProductViewController.h"
#import "AddDishViewController.h"
#import "Dish.h"
#import "DetailDishViewController.h"
#import "Product.h"
#import "DetailProductViewController.h"
#import "AbstractMedtronicChooseElementController.h"
#import "FastCreateAddIngredientsDishViewController.h"
#import "MedtronicConstants.h"

@implementation MealIngredientsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationController setTitle: @"Dodaj składnik"];
    
    //UINavigationItem * item = [self myRealNavigationItem];
    //[[self myRealNavigationItem] setTitle:@"Dodaj składnik"];
    
    [((UIButton *)[buttonsArray objectAtIndex:0]) setTitle:@"Wszystkie" forState:UIControlStateNormal];
    [((UIButton *)[buttonsArray objectAtIndex:1]) setTitle:@"Potrawy" forState:UIControlStateNormal];
    [((UIButton *)[buttonsArray objectAtIndex:2]) setTitle:@"Produkty" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishWasNotAdded:) name:@"Dish_not_added" object:nil];
    
    [self addPlusButton];
    [plusButton setHidden:YES];
    [plusButton setTitle:@"Dodaj" forState:UIControlStateNormal];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishWasAdded:) name:@"Dish_added" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishWasAdded:) name:@"Product_added" object:nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initControllers{
    
    controllersArray = [[NSMutableArray alloc] init];
    
    [controllersArray addObject: [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: DISH_PRODUCT andMainFilter: FAVOURITE]] ];
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: DISH andMainFilter: ALL]]];
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: PRODUCT andMainFilter: ALL]]];

    [self setAddDelegates];
}

- (IBAction)exclusiveButtonClicked:(id)sender{
    [super exclusiveButtonClicked: sender];
    
    UIButton * but = (UIButton *)sender;
    if (but == [buttonsArray objectAtIndex:0]) {
        [plusButton setHidden:YES];
    }
    else{
        [plusButton setHidden:NO];
    }
}

- (void)plusButtonClicked:(id)sender{
    if (selectedIndex == 1) {
        
        NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicFastCreateDishController" owner:nil options:nil];
        UINavigationController * navController = [arr objectAtIndex:0];
        
        [[self myRealNavigationController] presentViewController: navController animated: YES completion:nil];
        
        if ([[navController.viewControllers objectAtIndex:0] isKindOfClass: [FastCreateAddIngredientsDishViewController class]]) {
            ((FastCreateAddIngredientsDishViewController *)[navController.viewControllers objectAtIndex:0]).addDishDelegate = self;
        }
        /*
        NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddDishController" owner:nil options:nil];
        UINavigationController * navController = [arr objectAtIndex:0];
        [[self myRealNavigationController] presentViewController:navController animated:YES completion: nil];
        if ([[navController.viewControllers objectAtIndex:0] isKindOfClass: [AddDishViewController class]]) {
            ((AddDishViewController *)[navController.viewControllers objectAtIndex:0]).addDishDelegate = self;
        }
        */
    }
    else if(selectedIndex == 2){
        
        /*
        NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddProductController" owner:nil options:nil];
        UINavigationController * navController = [arr objectAtIndex:0];
        
        MedtronicAboveNavigationController * above = [[navController viewControllers] objectAtIndex:0];
        above.rootView = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
        
        [[self myRealNavigationController] presentViewController:navController animated:YES completion: nil];
        ((AddProductViewController *)above.rootView).addProdDelegate = self;
        */
        
        NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddProductController" owner:nil options:nil];
        UINavigationController * navController = [arr objectAtIndex:0];
        
        MedtronicAboveNavigationController * above = [[navController viewControllers] objectAtIndex:0];
        above.rootView = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
        
        [[self myRealNavigationController] presentViewController: navController animated: YES completion:nil];
        
        ((AddProductViewController *)above.rootView).addProdDelegate = self;
    }
}


- (void)productWasAdded:(Product *)element{
    if (element) {
        DetailProductViewController * productView = [[DetailProductViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: element];
        productView.isInside = self.isInside;
        [[self myRealNavigationController] pushViewController: productView animated:YES];
    }
}

- (void)dishWasAdded:(Dish *)product{
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
    [[self myRealNavigationController] dismissViewControllerAnimated:YES completion: nil];
}

@end
