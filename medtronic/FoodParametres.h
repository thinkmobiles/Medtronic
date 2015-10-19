//
//  Utils.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FAT_KCAL 9.0f
#define PROTEIN_KCAL 4.0f
#define CARBS_KCAL 4.0f

@interface FoodParametres : NSObject


+ (double) countWWfromCarbs: (double) carbs andFibre: (double) fibre; 
+ (double) countWBTfromProtein: (double) protein andFat: (double) fat;
+ (double) countWMfromWW: (double) ww andWBT: (double) wbt;
+ (double) countWbtPerc: (double) wm forWBT: (double) wbt;
+ (double)countCaloriesFromCarbs:(double)carbs protein:(double)protein fat:(double)fat;

+ (NSString *) doubleString: (double) val;
+ (NSString *) intString: (int) val;
+ (NSArray *) countIngredientsFor: (float) newW forIngredients: (NSMutableArray *) ings;

@end
