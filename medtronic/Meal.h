//
//  Meal.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MealDish.h"
#import "Ingredient.h"

@interface Meal : MealDish{
    double mealWeight;
}

@property double mealWeight;

- (void) finishInitializing;

@end
