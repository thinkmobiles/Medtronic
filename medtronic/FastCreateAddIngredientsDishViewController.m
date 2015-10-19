//
//  FastCreateAddIngredientsDishViewController.m
//  medtronic
//
//  Created by LooksoftHD on 16.10.2012.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "FastCreateAddIngredientsDishViewController.h"
#import "Dish.h"
#import "WeightCookedViewController.h"
#import "FastCreateDetailDishViewController.h"


@implementation FastCreateAddIngredientsDishViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [[self myRealNavigationItem] setRightBarButtonItem:nil];
    
    UIButton * buttonOk = [self createNavigationBarButton:@"Wylicz"];
    [buttonOk addTarget:self action:@selector(okAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: buttonOk];
    [[self myRealNavigationItem] setRightBarButtonItem:plus];
    
    [self setTitle:@"Nowa potrawa"];
}

- (IBAction)okAdd:(id)sender{
    
    if ([ingredientsTable.ingredients count] == 0) {
        [self showError:@"Dodaj co najmniej jeden składnik"];
        return;
    }
    
    Dish * newOne = (Dish *)[[Dish alloc] initWithId: 0 andName: @""];
    double wholeWeight = 0;
    for (Ingredient * single in ingredientsTable.ingredients) {
        [newOne addIngredient: single];
        wholeWeight += single.weight;
    }
    //newOne.mealWeight = newOne.ingredientsWeight;
    //[newOne countAllNutricionFactsFor:100.0f];
    
    if (self.terminCheckbox.selected) {
        WeightCookedViewController * weight = [[WeightCookedViewController alloc] initWithNibName:@"WeightCookedViewController" bundle:nil];
        //weight.name = [self.nameText text];
        //weight.categories = catsChosen;
        weight.fastCreate = YES;
        
        weight.ingredients = [NSMutableArray arrayWithArray: [NSArray arrayWithArray: ingredientsTable.ingredients]];
        weight.addDishDelegate = addDishDelegate;
        [self.navigationController pushViewController:weight animated:YES];
        return;
    }
    
    FastCreateDetailDishViewController * details = [[FastCreateDetailDishViewController alloc] initWithNibName:@"FastCreateDetailDishViewController" andObject:newOne];
    details.dish = newOne;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        details.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.navigationController pushViewController: details animated:YES];
//    [details valueChanged: wholeWeight];
}


@end
