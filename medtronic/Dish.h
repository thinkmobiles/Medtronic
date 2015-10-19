//
//  Dish.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MealDish.h"

@interface Dish : MealDish{

    double weightCooked;
    double weightChangeFactor;
    
    Dish * originalValues;
}

@property double weightCooked;
@property double weightChangeFactor;

- (void) countAllNutricionFactsFor: (float) newW fromSuper: (BOOL) up;

@end
