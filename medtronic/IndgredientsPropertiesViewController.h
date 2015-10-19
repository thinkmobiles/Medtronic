//
//  IndgredientsPropertiesViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-02.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "IngredientsView.h"
#import "MealDish.h"
//#import "AddDishViewController.h"
#import "AddDishDelegate.h"
#import "AddIngredientWithWeightViewController.h"

@interface IndgredientsPropertiesViewController : AbstractMedtronicViewController
<IngredientsChangeDelegate, AddDishDelegate, AddIngredientWithWeightDelegate>{
    IngredientsView * ingredientsView;
    
//    id<IngredientsViewDelegate> ingredientsDelegate;
//    id<IngredientsChangeDelegate> changeDelegate;
    
    MealDish * mealDishToEdit;
    UIButton * saveButton;
}

@property (nonatomic, retain) MealDish * mealDishToEdit;
@property (nonatomic, strong) NSMutableArray * ingredientsToLoad;

@property (nonatomic, retain) IngredientsView * ingredientsView;
@property (nonatomic, assign) id<IngredientsViewDelegate> ingredientsDelegate;
@property (nonatomic, assign) id<IngredientsChangeDelegate> changeDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInside: (BOOL) ins;
- (void) setEditable: (MealDish *) mealDish;
- (void) addSaveButton;

- (void) addIngredientClicked: (id) sender;

@end
