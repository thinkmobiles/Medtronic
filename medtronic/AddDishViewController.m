//
//  AddDishViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AddDishViewController.h"
#import "WeightCookedViewController.h"
#import "ProductsViewController.h"
#import "Utils.h"
#import "Dish.h"

@implementation AddDishViewController
@synthesize terminCheckbox, addDishDelegate, alreadyPrepared, wasShownAlert, weightAfter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    alreadyPrepared = NO;
    
    addDishDelegate = nil;
    weightAfter = -1.0f;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle: @"Dodaj potrawę"];
    
    catsView.type = DISH;
    catsView.howMany = 5;
    wasShownAlert = NO;
    
    if (alreadyPrepared) {
        [self.ingredientsTable setHidden:YES];
        [self.lastLine setHidden:YES];
        [self.termicView setHidden:YES];
    }
}

- (void)viewDidUnload {
    [self setTerminCheckbox:nil];
    [self setTermicView:nil];
    [super viewDidUnload];
}


- (IBAction)buttonSelected:(id)sender {
    terminCheckbox.selected = !terminCheckbox.selected;
    if (terminCheckbox.selected && !wasShownAlert) {
        wasShownAlert = YES;
        UIAlertView * v = [[UIAlertView alloc] initWithTitle:@"UWAGA" message:@"Podczas obróbki termicznej indeks glikemiczny może ulec zmianie" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [v show];
    }
}


- (IBAction)addElement:(id)sender {
    if (!mealIngsView) {
        mealIngsView = [[ProductsViewController alloc] initWithNibName:@"AbstractMedtronicExclusiveButtonsController" bundle:nil];
        mealIngsView.addDelegate = self;
        mealIngsView.forceNotInside = YES;
        [mealIngsView setAddDelegates];
        [[mealIngsView myRealNavigationItem] setTitle:@"Dodaj składnik"];
    }
    [self.navigationController pushViewController: mealIngsView animated:YES];
    [[mealIngsView myRealNavigationItem] setTitle:@"Dodaj składnik"];
}


- (void)okAdd:(id)sender{
    
    NSString * err = nil;
    if ((err = [self validate])) {
        [self showMessage: err];
        return;
    }
    
    if (terminCheckbox.selected) {
        WeightCookedViewController * weight = [[WeightCookedViewController alloc] initWithNibName:@"WeightCookedViewController" bundle:nil];
        weight.name = [self.nameText text];
        weight.categories = catsChosen;
        weight.ingredients = [NSMutableArray arrayWithArray: [NSArray arrayWithArray: ingredientsTable.ingredients]];
        weight.addDishDelegate = addDishDelegate;
        [self.navigationController pushViewController:weight animated:YES];
    }
    else{
        
        int next = [[SQLiteController sharedSingleton] getNextElementId];
        
        MealDish * newOne = [[MealDish alloc] initWithId: next andName: self.nameText.text];
        for (Ingredient * single in ingredientsTable.ingredients) {
            single.scalingFactor = 1.0f;
            [newOne addIngredient: single];
        }
        double weightBefore = newOne.ingredientsWeight;
        [newOne countAllNutricionFactsFor:100.0f];
        
        if (weightAfter > 0) {
            
            double cooked = weightAfter*100.0f/weightBefore;
            
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
                
                NSLog(@"ADD: %@", addSql);
                
                [[SQLiteController sharedSingleton] commitTransaction: addSql];
                
                // let's add categories
                NSMutableString * allCats = [[NSMutableString alloc] initWithString:@""];
                for (Category * cat in catsChosen) {
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
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:dish forKey:@"element"];
            [dict setObject: [NSNumber numberWithInt: isInside ? 1 : 0] forKey:@"inside"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Dish_added" object:self userInfo: dict];
            
            if (alreadyPrepared) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Dish_not_added" object:self userInfo:nil];
            }
            else{
                [self dismissViewControllerAnimated:YES completion: nil];
            }

            
            return;
        }
        
        // let's add it
        //NSMutableString * name = [NSMutableString stringWithFormat:@"%@", nameText.text];
        
        NSLog(@"kcal: %f", newOne.kcal);
        
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
        [addSql appendFormat:@"'%d',", DISH];   // type
        [addSql appendFormat:@"'0',"];   // is_favourite
        [addSql appendFormat:@"'0',"];   // weight_cooked
        [addSql appendFormat:@"'1',"];   // is_user_defined
        [addSql appendFormat:@"null,"];   // img_name
        [addSql appendFormat:@"date('now'),"];   // date_created
        [addSql appendFormat:@"null);"];   // weight_meal
        
        [[SQLiteController sharedSingleton] commitTransaction: addSql];
        
        // let's add categories
        NSMutableString * allCats = [[NSMutableString alloc] initWithString:@""];
        for (Category * cat in catsChosen) {
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
        /*
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:dish forKey:@"element"];
        [dict setObject: [NSNumber numberWithInt: isInside ? 1 : 0] forKey:@"inside"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dish_added" object:self userInfo: dict];
        */
        [self showMessage:@"Potrawa została dodana"];
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:dish forKey:@"element"];
        [dict setObject: [NSNumber numberWithInt: isInside ? 1 : 0] forKey:@"inside"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dish_added" object:self userInfo: dict];
        
        if (alreadyPrepared) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Dish_not_added" object:self userInfo:nil];
//            [self.parentViewController dismissViewControllerAnimated:YES completion: nil];
        }
        else{
            [self dismissViewControllerAnimated:YES completion: nil];
        }
    }
}

- (NSString *) validate{
    if ([self.nameText.text length] == 0) {
        return @"Wpisz nazwę potrawy";
    }
    else if(catsChosen == nil || [catsChosen count] ==0){
        return @"Wybierz od 1 do 5 kategorii potrawy";
    }
    else if([ingredientsTable.ingredients count] == 0){
        return @"Wybierz produkty, z których jest przygotowana potrawa";
    }
    return nil;
}

- (void)cancel:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dish_not_added" object:self userInfo:nil];
}

@end
