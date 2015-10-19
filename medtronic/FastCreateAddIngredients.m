//
//  FastCreateAddIngredients.m
//  medtronic
//
//  Created by Apple Saturn on 12-10-12.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "FastCreateAddIngredients.h"
#import "Meal.h"
#import "FastCreateDetailMealViewController.h"

@implementation FastCreateAddIngredients


- (void)viewDidLoad{
    [super viewDidLoad];
    [[self myRealNavigationItem] setRightBarButtonItem:nil];
    
    UIButton * buttonOk = [self createNavigationBarButton:@"Wylicz"];
    [buttonOk addTarget:self action:@selector(okAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: buttonOk];
    [[self myRealNavigationItem] setRightBarButtonItem:plus];
}

- (IBAction)okAdd:(id)sender{
    
    if ([ingredientsTable.ingredients count] == 0) {
        [self showError:@"Dodaj co najmniej jeden składnik"];
        return;
    }
    
    Meal * newOne = [[Meal alloc] initWithId: 0 andName: @""];
    for (Ingredient * single in ingredientsTable.ingredients) {
        [newOne addIngredient: single];
    }
    newOne.mealWeight = newOne.ingredientsWeight;
    [newOne countAllNutricionFactsFor:100.0f];

    FastCreateDetailMealViewController * details = [[FastCreateDetailMealViewController alloc] initWithNibName:@"FastCreateDetailMealViewController" andObject:newOne];
    details.meal = newOne;
    [self.navigationController pushViewController: details animated:YES];
}

@end
