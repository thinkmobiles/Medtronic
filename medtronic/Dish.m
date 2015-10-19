//
//  Dish.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Dish.h"
#import "Utils.h"
#import "FoodParametres.h"

@implementation Dish

@synthesize weightCooked, weightChangeFactor;

- (id)initWithId:(int)_theid andName:(NSString *)_name{
    self = [super initWithId:_theid andName:_name];
    weightChangeFactor = 1.0f;
    return self;
}

- (MedtronicObject *) clone{
    return [[Dish alloc] init];
}

- (void) fillWithMoreInfo: (sqlite3_stmt *) details{
    [super fillWithMoreInfo: details];
    weightCooked = sqlite3_column_double(details, 13);
}

- (void) countAllNutricionFactsFor: (float) newW fromSuper: (BOOL) up{
    if (up) {
        [super countAllNutricionFactsFor: newW];
    }
    else{
        [self countAllNutricionFactsFor: newW];
    }
}

- (void) countAllNutricionFactsFor: (float) newW{
    
    double allW = 0.0f;
    for (Ingredient * ing in ingredients) {
        allW += ing.weight;
    }
    
    if (!originalValues) {
        weightChangeFactor = 1.0f;
        
        originalValues = [[Dish alloc] initWithId:theid andName:name];
        if (weightCooked != 100.0f && weightCooked > 0) {
            weightChangeFactor = 100.0f/weightCooked;
        }
        /*
        if (weightCooked != 100.0f && weightCooked > 0) {
            originalValues.weightCooked = 100.0f;
            originalValues.ingredientsWeight = allW*100.0f/weightCooked;
            
            ingredients = [NSMutableArray arrayWithArray: [FoodParametres countIngredientsFor: originalValues.ingredientsWeight forIngredients: ingredients]];
            
            originalValues.kcal = kcal *100.0f/weightCooked;
            originalValues.protein = protein *100.0f/weightCooked;
            originalValues.fat =  fat*100.0f/weightCooked;
            originalValues.carbs = carbs *100.0f/weightCooked;
            originalValues.fiber =  fiber*100.0f/weightCooked;
            
            weightChangeFactor = 100.0f/weightCooked;
        }else{
            originalValues.ingredientsWeight = allW;
            
            originalValues.kcal = kcal;
            originalValues.protein = protein;
            originalValues.fat =  fat;
            originalValues.carbs = carbs;
            originalValues.fiber =  fiber;
        }
         */
    }
    ingredientsWeight = allW;
    
    if ((int)ingredientsWeight != (int)newW) {
        ingredients = [NSMutableArray arrayWithArray: [FoodParametres countIngredientsFor: newW forIngredients: ingredients]];
        allW = newW;
        //factor = newW/originalValues.ingredientsWeight;
    }

    ingredientsWeight = newW;
    
    // na 100g
    /*
    kcal = originalValues.kcal;
    protein = originalValues.protein;
    fat = originalValues.fat;
    carbs = originalValues.carbs;
    fiber = originalValues.fiber;
    */

    ww = [FoodParametres countWWfromCarbs: carbs andFibre: fiber];
    wbt = [FoodParametres countWBTfromProtein: protein andFat:fat];
    wm = [FoodParametres countWMfromWW: ww andWBT:wbt];
    wbt_proc = [FoodParametres countWbtPerc: wm forWBT:wbt];
    
}



@end
