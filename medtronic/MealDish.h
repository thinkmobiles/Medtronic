//
//  MealDish.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-12.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Element.h"
#import "Ingredient.h"

@interface MealDish : Element{
    NSMutableArray * ingredients;
    double ingredientsWeight;
}

@property double ingredientsWeight;
@property (nonatomic, retain) NSMutableArray * ingredients;

- (void) addIngredient: (Ingredient *) ing; 
- (void) countAllNutricionFactsFor: (float) newW;

@end
