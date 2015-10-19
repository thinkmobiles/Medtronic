//
//  MealDish.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-12.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MealDish.h"
#import "FoodParametres.h"

@implementation MealDish

@synthesize ingredients, ingredientsWeight;

- (MedtronicObject *) clone{
    return [[MealDish alloc] init];
}

- (void) addIngredient: (Ingredient *) ing{
    
    if (!ingredients) {
        ingredients = [[NSMutableArray alloc] init];
        ingredientsWeight = 0.0f;
    }
    
    [ingredients addObject: ing];
    ingredientsWeight += ing.weight;
}

- (void) countAllNutricionFactsFor: (float) newW{
    
    double allW = 0.0f;
    for (Ingredient * ing in ingredients) {
        allW += ing.weight;
    }
    
    if (allW != newW) {
        ingredients = [NSMutableArray arrayWithArray: [FoodParametres countIngredientsFor: newW forIngredients: ingredients]];
        allW = newW;
    }
    ingredientsWeight = newW;
    
    kcal = 0.0f;
    protein =0.0f;
    fat = 0.0f;
    carbs = 0.0f;
    fiber = 0.0f;
    
    for (Ingredient * ing in ingredients) {
        
        //NSLog(@"kcal add: %f", (ing.weight *ing.scalingFactor * ing.element.kcal)/allW);
        
        kcal        += (ing.weight *ing.scalingFactor * ing.element.kcal);
        protein     += (ing.weight *ing.scalingFactor * ing.element.protein);
        fat         += (ing.weight *ing.scalingFactor * ing.element.fat);
        carbs       += (ing.weight *ing.scalingFactor * ing.element.carbs);
        fiber       += (ing.weight *ing.scalingFactor * ing.element.fiber);
    }
    
    kcal = kcal/allW;
    protein /= allW;
    fat /= allW;
    carbs /= allW;
    fiber /= allW;
    
    NSLog(@"kcal after: %f", kcal);
    
    ww = [FoodParametres countWWfromCarbs: carbs andFibre: fiber];
    wbt = [FoodParametres countWBTfromProtein: protein andFat:fat];
    wm = [FoodParametres countWMfromWW: ww andWBT:wbt];
    wbt_proc = [FoodParametres countWbtPerc: wm forWBT:wbt];
}


@end
