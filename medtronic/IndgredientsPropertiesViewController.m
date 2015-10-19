//
//  IndgredientsPropertiesViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-02.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "IndgredientsPropertiesViewController.h"
#import "Meal.h"
#import "Dish.h"
#import "SQLiteController.h"
#import "WeightCookedViewController.h"
#import "RectUtils.h"
#import "ProductsViewController.h"
#import "MealIngredientsViewController.h"

@implementation IndgredientsPropertiesViewController

@synthesize
ingredientsView,
ingredientsDelegate,
mealDishToEdit, changeDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isInside = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInside: (BOOL) ins{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isInside = ins;
    }
    return self;
}

- (void) setEditable: (MealDish *) mealDish{
    self.mealDishToEdit = mealDish;
    ingredientsView.changeDelegate = self;
}

- (void)ingredientsChanged{
    if (!saveButton && mealDishToEdit) {
        [self addSaveButton];
    }
}

- (void) addSaveButton{
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage: [UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
    
    [saveButton setTitle:@"Zapisz" forState:UIControlStateNormal];
    [saveButton.titleLabel setFont: [UIFont boldSystemFontOfSize:12]];
    [saveButton.titleLabel setTextColor: [UIColor whiteColor]];
    
    [saveButton setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"small_button.png"].size.width-20, [UIImage imageNamed:@"small_button.png"].size.height)];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: saveButton];
    [saveButton addTarget:self action:@selector(okAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self myRealNavigationItem] setRightBarButtonItem: plus];
}

- (void)okAdd:(id)sender{
    if ([mealDishToEdit isKindOfClass:[Dish class]] && [((Dish*)mealDishToEdit) weightCooked] > 0) {
        
        WeightCookedViewController * weight = [[WeightCookedViewController alloc] initWithNibName:@"WeightCookedViewController" bundle:nil];
        weight.name = mealDishToEdit.name;
        weight.categories = nil;
        weight.isInside = self.isInside;
        if (isInside) {
            weight.forceNotInside = NO;
        }
        weight.ingredients = [NSMutableArray arrayWithArray:[NSArray arrayWithArray: ingredientsView.ingredients]];
        weight.addDishDelegate = self;
        weight.dishToEdit = (Dish*)mealDishToEdit;
        weight.changeDelegate = self.changeDelegate;

        [[self myRealNavigationController] pushViewController:weight animated:YES];

        //[self showMessage:@"Funkcja niedostępna w tej wersji aplikacji"];
    }
    else{
        
        BOOL dish = [mealDishToEdit isKindOfClass:[Dish class]];
        
        // let's update meal
        Meal * meal = [[Meal alloc] initWithId:mealDishToEdit.theid andName:mealDishToEdit.name];
        
        for (Ingredient * single in ingredientsView.ingredients) {
            [meal addIngredient: single];
        }
        
        if (!dish) {
             meal.mealWeight = meal.ingredientsWeight;
        }
        
        [meal countAllNutricionFactsFor:100.0f];
        
//        NSLog(@"meal w: %f", meal.mealWeight);
        
        // remove all current ingredients
        NSMutableString * str = [[NSMutableString alloc] initWithFormat: @"DELETE FROM element_has_element WHERE id_parent=%d;", meal.theid];
        for (Ingredient * ing in meal.ingredients) {
            [str appendFormat: @"INSERT INTO element_has_element VALUES ('%d','%d','%f');", ing.element.theid, meal.theid, ing.weight];
        }
        
        if (dish) {
            [str appendFormat:@"UPDATE element SET fat='%f', fiber='%f', carbs='%f', kcal='%f', protein='%f', ww='%f', wbt='%f', wm='%f', wbt_proc='%f' WHERE id='%d';", 
             meal.fat, meal.fiber, meal.carbs, meal.kcal, meal.protein, meal.ww, meal.wbt, meal.wm, meal.wbt_proc, meal.theid];
        }
        else{
            [str appendFormat:@"UPDATE element SET fat='%f', fiber='%f', carbs='%f', kcal='%f', protein='%f', ww='%f', wbt='%f', wm='%f', wbt_proc='%f', weight_meal='%f' WHERE id='%d';", 
             meal.fat, meal.fiber, meal.carbs, meal.kcal, meal.protein, meal.ww, meal.wbt, meal.wm, meal.wbt_proc, meal.mealWeight, meal.theid];
        }
        
        [[SQLiteController sharedSingleton] commitTransaction: str];
        
        [self showMessage: dish ? @"Potrawa została uaktualniona" : @"Posiłek został uaktualniony"];
        [changeDelegate ingredientsChanged];
        [self customGoBack];
    }
}

- (void)dishWasAdded:(Dish *)element{
    //[self showMessage:@"Potrawa została uaktualniona"];
    [changeDelegate ingredientsChanged];
    [[self myRealNavigationController] popViewControllerAnimated:YES];
}

- (void)customGoBack{
    [super customGoBack];
    [ingredientsDelegate detailsDismiss: ingredientsView.ingredients];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [RectUtils logRect:self.view.frame withTitle: @"frame all"];
    
    [[self myRealNavigationItem] setTitle: mealDishToEdit ? @"Edycja składników" : @"Wartości odżywcze"];
    
    ingredientsView = [[IngredientsView alloc] initDetailsWithFrame: CGRectMake(0, isInside ? 44 : 0, self.view.frame.size.width,
                                                                                [UIScreen mainScreen].bounds.size.height-19-44 - (isInside ? 50+44 : 0)) ];
    ingredientsView.textFieldDelegate = self;
    
    [self.view addSubview: ingredientsView];
    
    if (mealDishToEdit) {
        for (Ingredient * ing in mealDishToEdit.ingredients) {
            [ingredientsView addNewElement: ing];
        }
        ingredientsView.changeDelegate = self;
    
        UIButton * addIngredientButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [addIngredientButton setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
        [addIngredientButton setBackgroundImage:[UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
        
        [addIngredientButton setTitle:@"Dodaj składnik" forState:UIControlStateNormal];
        [addIngredientButton.titleLabel setFont: [UIFont boldSystemFontOfSize:12]];
        [addIngredientButton.titleLabel setTextColor: [UIColor whiteColor]];
        [addIngredientButton sizeToFit];
        
        [addIngredientButton addTarget:self action:@selector(addIngredientClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [addIngredientButton setFrame: CGRectMake(self.view.frame.size.width-addIngredientButton.frame.size.width-15, 44, addIngredientButton.frame.size.width+10, [UIImage imageNamed:@"small_button.png"].size.height)];
        [self.view addSubview: addIngredientButton];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addIngredientButton.frame)+1, self.view.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor lightTintColor];
        [self.view addSubview: lineView];
        
        ingredientsView.frame = [RectUtils rect: ingredientsView.frame offsetYSmallerHeight: addIngredientButton.frame.size.height+2];
    }
    
    if (_ingredientsToLoad) {
        for (Ingredient * ing in _ingredientsToLoad) {
            [ingredientsView addNewElement: ing];
        }
    }
}

- (void)addIngredientClicked:(id)sender{
    
    if (mealDishToEdit.type == DISH) {
        ProductsViewController *   mealIngsView = [[ProductsViewController alloc] initWithNibName:@"AbstractMedtronicExclusiveButtonsController" bundle:nil];
        mealIngsView.addDelegate = self;
//        mealIngsView.forceNotInside = YES;
        mealIngsView.isInside = YES;
        [mealIngsView setAddDelegates];
        
        [self.navigationController pushViewController: mealIngsView animated:YES];
        [[mealIngsView myRealNavigationItem] setTitle:@"Dodaj składnik"];
    }
    else{
        MealIngredientsViewController * mealIngsView = [[MealIngredientsViewController alloc] initWithNibName:@"AbstractMedtronicExclusiveButtonsController" bundle:nil];
        mealIngsView.addDelegate = self;
        mealIngsView.isInside = YES;
        [mealIngsView setTitle:@"Dodaj składnik"];
        [self.navigationController pushViewController: mealIngsView animated:YES];
    }
}

#pragma mark - AddIngredientWithWeightDelegate

- (void) ingredientToAdd: (Ingredient *) newOne{
    [ingredientsView addNewElement: newOne];
    [self ingredientsChanged];
}

@end
