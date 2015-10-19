//
//  ElementSerializable.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-04.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ElementSerializable.h"
#import "JSON.h"
#import "SQLiteController.h"
#import "Ingredient.h"
#import "Utils.h"

@implementation ElementSerializable

@synthesize weightMeal, weightCooked;

- (id)initWithId:(int)_theid andName:(NSString *)_name{
    self = [super initWithId:_theid andName:_name];
    
    ingredients = [[NSMutableArray alloc] init];
    categories = [[NSMutableArray alloc] init];
    
    return self;
}

- (MedtronicObject *) clone{
    return [[ElementSerializable alloc] init];
}

- (void)fillWithId:(int)_theid andName:(NSString *)_name moreIfNecessary:(sqlite3_stmt *)selectstmt{
    [super fillWithId:_theid andName:_name moreIfNecessary:selectstmt];
    [self fillWithMoreInfo:selectstmt];
}


- (void) fillWithMoreInfo: (sqlite3_stmt *) details{
    [super fillWithMoreInfo:details];
    weightCooked = sqlite3_column_double(details, 13);
    weightMeal = sqlite3_column_double(details, 17);
}

- (NSDictionary *) prepareSerializedObject{
    
    if (!ingredients) {
        ingredients = [[NSMutableArray alloc] init];
        categories = [[NSMutableArray alloc] init];
    }
    
    [ingredients removeAllObjects];
    [categories removeAllObjects];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject: [NSNumber numberWithInt: theid] forKey:@"id"];
    [dict setObject: name forKey:@"name"];
    
    [dict setObject: [NSNumber numberWithDouble: wm] forKey:@"wm"];
    [dict setObject: [NSNumber numberWithDouble: wbt_proc] forKey:@"wbt_proc"];
    [dict setObject: [NSNumber numberWithDouble: fat] forKey:@"fat"];
    [dict setObject: [NSNumber numberWithDouble: kcal] forKey:@"kcal"];
    [dict setObject: [NSNumber numberWithInt: type] forKey:@"type"];
    [dict setObject: [NSNumber numberWithDouble: fiber] forKey:@"fiber"];
    [dict setObject: [NSNumber numberWithDouble: weightMeal] forKey:@"weight_meal"];
    [dict setObject: [NSNumber numberWithDouble: wbt] forKey:@"wbt"];
    [dict setObject: [NSNumber numberWithDouble: weightCooked] forKey:@"weight_cooked"];
    [dict setObject: [NSNumber numberWithDouble: ww] forKey:@"ww"];
    [dict setObject: [NSNumber numberWithDouble: protein] forKey:@"protein"];
    [dict setObject: [NSNumber numberWithDouble: carbs] forKey:@"carbs"];
    [dict setObject: isFavourite ? @"true" : @"false" forKey:@"is_favourite"];
    
    // ingredients
    NSArray * plainIngs = [[SQLiteController sharedSingleton] getAllIngredientsFor: theid];
    
    for (Ingredient * ing in plainIngs) {
        NSMutableDictionary * dictIng = [[NSMutableDictionary alloc] init];
        [dictIng setObject: [NSNumber numberWithInt: ing.element.theid] forKey:@"id"];
        [dictIng setObject: [NSNumber numberWithDouble: ing.weight] forKey:@"weight"];
        
        [ingredients addObject: dictIng];
    }
    
    [dict setObject: ingredients forKey:@"ingredients"];
    
    
    // categories
    categories = [NSMutableArray arrayWithArray: [[SQLiteController sharedSingleton] getAllCategoryIdsFor: theid] ];
    [dict setObject: categories forKey: @"categories"];
    
    return dict;
}

- (NSString *)deserializeFromJson:(NSDictionary *)dict{
    
    theid = [Utils getIntFromDict:dict forKey:@"id"];
    name = [Utils getStringFromDict:dict forKey:@"name"];
    wm = [Utils getDoubleFromDict:dict forKey:@"wm"];
    ww = [Utils getDoubleFromDict:dict forKey:@"ww"];
    wbt = [Utils getDoubleFromDict:dict forKey:@"wbt"];
    wbt_proc = [Utils getDoubleFromDict:dict forKey:@"wbt_proc"];
    fat = [Utils getDoubleFromDict:dict forKey:@"fat"];
    protein = [Utils getDoubleFromDict:dict forKey:@"protein"];
    fiber = [Utils getDoubleFromDict:dict forKey:@"fiber"];
    carbs = [Utils getDoubleFromDict:dict forKey:@"carbs"];
    kcal = [Utils getDoubleFromDict:dict forKey:@"kcal"];
    type = [Utils getIntFromDict:dict forKey:@"type"];
    weightMeal = [Utils getDoubleFromDict:dict forKey:@"weight_meal"];
    weightCooked = [Utils getDoubleFromDict:dict forKey:@"weight_cooked"];
    isFavourite = [[dict valueForKey:@"is_favourite"] boolValue];
    
    NSMutableString * addSql = [NSMutableString stringWithFormat:@"INSERT INTO element VALUES ("];
    [addSql appendFormat:@"'%d',", theid]; // id
    [addSql appendFormat:@"'%@',", name];   // name
    [addSql appendFormat:@"'%f',", fat];   // fat
    [addSql appendFormat:@"'%f',", fiber];   // fiber
    [addSql appendFormat:@"'%f',", carbs];   // carbs
    [addSql appendFormat:@"'%f',", kcal];   // kcal
    [addSql appendFormat:@"'%f',", protein];   // protein
    [addSql appendFormat:@"'%f',", ww];   // ww
    [addSql appendFormat:@"'%f',", wbt];   // wbt
    [addSql appendFormat:@"'%f',", wm];   // wm
    [addSql appendFormat:@"'%f',", wbt_proc];   // wbt_proc
    [addSql appendFormat:@"'%d',", type];   // type
    [addSql appendFormat:@"'%d',", isFavourite ? 1 : 0];   // is_favourite
    [addSql appendFormat:@"'%f',", weightCooked];   // weight_cooked
    [addSql appendFormat:@"'1',"];   // is_user_defined
    [addSql appendFormat:@"null,"];   // img_name
    [addSql appendFormat:@"date('now'),"];   // date_created
    [addSql appendFormat:@"'%f');", weightMeal];   // weight_meal

    
    NSArray * cats = [dict objectForKey:@"categories"];
    for (NSNumber * num in cats) {
        [addSql appendFormat: @"INSERT INTO element_has_category VALUES ('%d','%d');", theid, [num intValue]];
    }
    
    NSArray * ings = [dict objectForKey:@"ingredients"];
    for (NSDictionary * singleIng in ings) {
        int elementId = [Utils getIntFromDict:singleIng forKey:@"id"];
        double w = [Utils getDoubleFromDict:singleIng forKey:@"weight"];
        
        [addSql appendFormat: @"INSERT INTO element_has_element VALUES ('%d','%d','%f');", elementId, theid, w];
    }

    NSLog(@"MY ADD:\n%@\n", addSql);
    
    return addSql;
}


@end
