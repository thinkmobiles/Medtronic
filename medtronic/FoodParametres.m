//
//  Utils.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "FoodParametres.h"
#import "Element.h"
#import "Ingredient.h"

@implementation FoodParametres



+ (double) countWWfromCarbs: (double) carbs andFibre: (double) fibre{
    return (carbs - fibre)/10.0f;
}

+ (double) countWBTfromProtein: (double) protein andFat: (double) fat{
    return (4.0f*protein + 9.0f*fat)/100.0f;
}

+ (double) countWMfromWW: (double) ww andWBT: (double) wbt{
    return ww+wbt;
}

+ (double) countWbtPerc: (double) wm forWBT: (double) wbt{
    return wm == 0 ? 0 : wbt*100.0f/wm;
}

+ (double)countCaloriesFromCarbs:(double)carbs protein:(double)protein fat:(double)fat{
    return 4.0f*carbs + 4.0f*protein + 9.0f*fat;
}

+ (NSString *) doubleString: (double) val{
    return [NSString stringWithFormat:@"%.1f", val];
}

+ (NSString *) intString: (int) val{
     return [NSString stringWithFormat:@"%d", val];
}

+ (NSArray *) countIngredientsFor: (float) newW forIngredients: (NSMutableArray *) ings{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    double allW = 0.0f;
    for (Ingredient * single in ings) {
        allW += single.weight;
    }
    
    double factor = newW/allW;
    
    for (Ingredient * single in ings) {
        Ingredient * newOne = [[Ingredient alloc] initWithWeight: single.weight*factor andElement: single.element];
        [array addObject: newOne];
    }
    return array;
}



@end
