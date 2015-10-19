//
//  WeightCookedViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-03.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "WeightCookedViewController.h"
#import "FoodParametres.h"
#import "SQLiteController.h"
#import "Dish.h"
#import "Category.h"
#import "Utils.h"
#import "FastCreateDetailDishViewController.h"

@implementation WeightCookedViewController
@synthesize ingredientsWieghtLabel;
@synthesize afterWeightTextbox;
@synthesize subView;
@synthesize infoLabel;

@synthesize
ingredients,
name,
categories,
addDishDelegate,
dishToEdit,
fastCreate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    isInside = NO;
    forceNotInside = YES;
    dishToEdit = nil;
    fastCreate = NO;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[self myRealNavigationItem] setTitle:@"UWAGA!"];
    
    [self addOkButton];
    
    ings = [[IngredientsView alloc] initOnlyDetailsWithFrame: CGRectMake(0, 0, self.subView.frame.size.width, self.subView.frame.size.height)];
    [self.subView addSubview:ings];
    if (isInside) {
        [self.subView setFrame: CGRectMake(self.subView.frame.origin.x, self.subView.frame.origin.y-48, self.subView.frame.size.width, self.subView.frame.size.height)];
        [self.infoLabel setFrame: CGRectMake(self.infoLabel.frame.origin.x, self.infoLabel.frame.origin.y-48, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height)];
    }
    
    double allW = 0.0f;
    for (Ingredient * single in ingredients) {
        allW += single.weight;
    }
    weightBefore = allW;
    double factor = 100.0f/weightBefore;
    
    // set for 100 g of all ingredients
    for (Ingredient * single in ingredients) {
        Ingredient * singleOther = [[Ingredient alloc] initWithWeight:single.weight*factor andElement: single.element];
        [ings addNewElement: singleOther];
    }
    [ings countForAllIngredients];
    
    [ingredientsWieghtLabel setText: [NSString stringWithFormat:@"%@ g", [FoodParametres doubleString: allW]]];
    
    [afterWeightTextbox setText: [FoodParametres doubleString: allW]];
    
    [self.mySlider setMaximumValue: allW];
    [self.mySlider setValue: allW];
    
    self.sliderDelegate = self;
}

- (void)valueChanged:(double)newVal{
    [afterWeightTextbox setText: [FoodParametres doubleString: newVal]];
    double value = [afterWeightTextbox.text doubleValue];
    double factor = weightBefore/value;
    
    for (Ingredient * single in ings.ingredients) {
        single.scalingFactor = factor;
    }
    [ings countForAllIngredients];
}

- (void)okAdd:(id)sender{
    
    if (fastCreate) {
        Dish * newOne = (Dish *)[[Dish alloc] initWithId: 0 andName: @""];
        for (Ingredient * single in ings.ingredients) {
            single.scalingFactor = 1.0f;
            [newOne addIngredient: single];
        }
        [newOne countAllNutricionFactsFor: weightBefore fromSuper:YES];
        
        newOne.weightCooked = [[afterWeightTextbox text] floatValue];/*100.0f/weightBefore*/;
        newOne.weightChangeFactor = weightBefore/newOne.weightCooked;

        FastCreateDetailDishViewController * details = [[FastCreateDetailDishViewController alloc] initWithNibName:@"FastCreateDetailDishViewController" andObject:newOne];
        details.dish = newOne;
        [self.navigationController pushViewController: details animated:YES];
        [details valueChanged: [[afterWeightTextbox text] floatValue]];
        return;
    }
    
    int next = dishToEdit ? dishToEdit.theid : [[SQLiteController sharedSingleton] getNextElementId];
    MealDish * newOne = [[MealDish alloc] initWithId: next andName: dishToEdit ? dishToEdit.name : name];
    
    for (Ingredient * single in ings.ingredients) {
        single.scalingFactor = 1.0f;
        [newOne addIngredient: single];
    }
    [newOne countAllNutricionFactsFor:100.0f];
    
    double cooked = [[afterWeightTextbox text] floatValue]*100.0f/weightBefore;
    
    // edit
    if (dishToEdit) {
        
        // remove all current ingredients
        NSMutableString * str = [[NSMutableString alloc] initWithFormat: @"DELETE FROM element_has_element WHERE id_parent=%d;", newOne.theid];
        for (Ingredient * ing in newOne.ingredients) {
            [str appendFormat: @"INSERT INTO element_has_element VALUES ('%d','%d','%f');", ing.element.theid, next, ing.weight];
        }
        
        [str appendFormat:@"UPDATE element SET fat='%f', fiber='%f', carbs='%f', kcal='%f', protein='%f', ww='%f', wbt='%f', wm='%f', wbt_proc='%f', weight_cooked='%f' WHERE id='%d';", newOne.fat, newOne.fiber, newOne.carbs, newOne.kcal, newOne.protein, newOne.ww, newOne.wbt, newOne.wm, newOne.wbt_proc, cooked, newOne.theid];
                
//        NSLog(@"%@", str);
        
        [[SQLiteController sharedSingleton] commitTransaction: str];
        
        [self showMessage:@"Potrawa została uaktualniona"];
        
        [[self myRealNavigationController] popViewControllerAnimated:NO];
        [addDishDelegate dishWasAdded: dishToEdit];
        [self.changeDelegate ingredientsChanged];
    }
    else{
        
        NSMutableString * addSql = [NSMutableString stringWithFormat:@"INSERT INTO element VALUES ("];
        [addSql appendFormat:@"'%d',", next]; // id
        [addSql appendFormat:@"'%@',", [Utils uppercaseSentence:newOne.name] ];   // name
        [addSql appendFormat:@"'%f',", newOne.fat];   // fat
        [addSql appendFormat:@"'%f',", newOne.fiber];   // fiber
        [addSql appendFormat:@"'%f',", newOne.carbs];   // carbs
        [addSql appendFormat:@"'%f',", newOne.kcal];   // kcal
        [addSql appendFormat:@"'%f',", newOne.protein];   // protein
        [addSql appendFormat:@"'%f',", newOne.ww];   // ww
        [addSql appendFormat:@"'%f',", newOne.wbt];   // wbt
        [addSql appendFormat:@"'%f',", newOne.wm];   // wm
        [addSql appendFormat:@"'%f',", newOne.wbt_proc];   // wbt_proc
        [addSql appendFormat:@"'%d',", DISH];   // type
        [addSql appendFormat:@"'0',"];   // is_favourite
        [addSql appendFormat:@"'%f',", cooked];   // weight_cooked
        [addSql appendFormat:@"'1',"];   // is_user_defined
        [addSql appendFormat:@"null,"];   // img_name
        [addSql appendFormat:@"date('now'),"];   // date_created
        [addSql appendFormat:@"null);"];   // weight_meal
#if DEBUG
        NSLog(@"ADD: %@", addSql);
#endif
        [[SQLiteController sharedSingleton] commitTransaction: addSql];
        
        // let's add categories
        NSMutableString * allCats = [[NSMutableString alloc] initWithString:@""];
        for (Category * cat in categories) {
            [allCats appendFormat: @"INSERT INTO element_has_category VALUES ('%d','%d');", next, cat.theid];
        }
        
        [[SQLiteController sharedSingleton] commitTransaction: allCats];
        
        // let's add all elements
        NSMutableString * allElements = [[NSMutableString alloc] initWithString:@""];
        for (Ingredient * ing in newOne.ingredients) {
            [allElements appendFormat: @"INSERT INTO element_has_element VALUES ('%d','%d','%f');", ing.element.theid, next, ing.weight];
        }
        [[SQLiteController sharedSingleton] commitTransaction: allElements];
        
        Dish * dish = [[Dish alloc] initWithId:next andName: [Utils uppercaseSentence: newOne.name]];
        [addDishDelegate dishWasAdded: dish];
        
        [self showMessage:@"Potrawa została dodana"];
        [self dismissViewControllerAnimated:YES completion: nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    double value = [textField.text doubleValue];
    double factor = weightBefore/value;
    
    for (Ingredient * single in ings.ingredients) {
        single.scalingFactor = factor;
    }
    [ings countForAllIngredients];
    [self.mySlider setValue: value];
}

- (void)viewDidUnload {
    [self setIngredientsWieghtLabel:nil];
    [self setAfterWeightTextbox:nil];
    [self setSubView:nil];
    [self setInfoLabel:nil];
    [super viewDidUnload];
}
@end
