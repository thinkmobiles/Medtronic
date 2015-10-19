//
//  AddMealViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AddMealViewController.h"
#import "CategoriesViewController.h"
#import "Meal.h"
#import "Utils.h"
#import "FastCreateDetailMealViewController.h"

@implementation AddMealViewController
@synthesize addElementButton;
//@synthesize myNavItem;
@synthesize nameText;
@synthesize chooseCategoryButton, myParent;

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"Dodaj posiłek"];
    
    catsView.type = MEAL;
    catsView.howMany = 1;
    
    [self.lastLine setHidden:YES];
    [self.ingredientsTable setHidden:YES];
}


- (IBAction)okAdd:(id)sender{
    NSString * err = nil;
    if ((err = [self validate])) {
        [self showMessage: err];
        return;
    }
    
    // let's add it
    int next = [[SQLiteController sharedSingleton] getNextElementId];
    
    Meal * newOne = [[Meal alloc] initWithId: next andName: self.nameText.text];
    for (Ingredient * single in ingredientsTable.ingredients) {
        [newOne addIngredient: single];
    }
    newOne.mealWeight = newOne.ingredientsWeight;
    [newOne countAllNutricionFactsFor:100.0f];
    
    //NSLog(@"New one kcal: %f", newOne.kcal);
    //NSMutableString * name = [NSMutableString stringWithFormat:@"%@", nameText.text];
    
    NSMutableString * addSql = [NSMutableString stringWithFormat:@"INSERT INTO element VALUES ("];
    [addSql appendFormat:@"'%d',", next]; // id
    [addSql appendFormat:@"'%@',", [Utils uppercaseSentence: newOne.name]];   // name
    [addSql appendFormat:@"'%f',", newOne.fat];   // fat
    [addSql appendFormat:@"'%f',", newOne.fiber];   // fiber
    [addSql appendFormat:@"'%f',", newOne.carbs];   // carbs
    [addSql appendFormat:@"'%f',", newOne.kcal];   // kcal
    [addSql appendFormat:@"'%f',", newOne.protein];   // protein
    [addSql appendFormat:@"'%f',", newOne.ww];   // ww
    [addSql appendFormat:@"'%f',", newOne.wbt];   // wbt
    [addSql appendFormat:@"'%f',", newOne.wm];   // wm
    [addSql appendFormat:@"'%f',", newOne.wbt_proc];   // wbt_proc
    [addSql appendFormat:@"'%d',", MEAL];   // type
    [addSql appendFormat:@"'0',"];   // is_favourite
    [addSql appendFormat:@"null,"];   // weight_cooked
    [addSql appendFormat:@"'1',"];   // is_user_defined
    [addSql appendFormat:@"null,"];   // img_name
    [addSql appendFormat:@"date('now'),"];   // date_created
    [addSql appendFormat:@"'%f');", newOne.mealWeight];   // weight_meal
    
    [[SQLiteController sharedSingleton] commitTransaction: addSql];
    
    // let's add categories
    NSMutableString * allCats = [[NSMutableString alloc] initWithString:@""];
    for (Category * cat in catsChosen) {
        [allCats appendFormat: @"INSERT INTO element_has_category VALUES ('%d','%d');", next, cat.theid];
    }
    
    // let's add all elements
    NSMutableString * allElements = [[NSMutableString alloc] initWithString: allCats];
    for (Ingredient * ing in newOne.ingredients) {
        [allElements appendFormat: @"INSERT INTO element_has_element VALUES ('%d','%d','%f');", ing.element.theid, next, ing.weight];
    }
    [[SQLiteController sharedSingleton] commitTransaction: allElements];
    
    [self showMessage:@"Posiłek został dodany"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Meal_added" object:self userInfo:[NSDictionary dictionaryWithObject:newOne forKey:@"element"]];
    
    //[self dismissModalViewControllerAnimated:YES];
    //[myParent customGoBack];
}

- (NSString *) validate{
    if ([self.nameText.text length] == 0) {
        return @"Wpisz nazwę posiłku";
    }
    else if(catsChosen == nil || [catsChosen count] == 0){
        return @"Wybierz kategorię";
    }
    else if([ingredientsTable.ingredients count] == 0){
        return @"Wybierz składniki, z których jest przygotowany posiłek";
    }
    return nil;
}


- (void)cancel:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Meal_not_added" object:self userInfo:nil];
}

@end
