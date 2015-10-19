//
//  DetailMealViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "DetailMealViewController.h"
#import "SQLiteController.h"
#import "IndgredientsPropertiesViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "FoodParametres.h"
#import "Product.h"
#import "Dish.h"
#import "DetailProductViewController.h"
#import "DetailDishViewController.h"
#import "Settings.h"
#import "RectUtils.h"

@implementation DetailMealViewController

@synthesize meal;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
        NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", object.theid];
        
        meal = [[Meal alloc] initWithId: object.theid andName:object.name];
        meal = (Meal*)[[SQLiteController sharedSingleton] execSelect:sel fillObject:meal];
        NSArray * ingredients = [[SQLiteController sharedSingleton] getAllIngredientsFor: meal.theid];
        
        for (Ingredient * ing in ingredients) {
            [meal addIngredient: ing];
        }
        [meal countAllNutricionFactsFor: meal.mealWeight];
    
    [self setTitle:@"Posiłki"];
    
    self.subValuesView.frame = CGRectMake(0, self.subValuesView.frame.origin.y, self.subValuesView.frame.size.width, [Utils isiPhone5] ? 311 : (311-88));
    
    detailsView = [[NutricionFactsAndIngredientsView alloc] initWithFrame:self.subValuesView.bounds andElement: meal];
    detailsView.delegate = self;
    detailsView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.subValuesView addSubview: detailsView];
    
    self.object = meal;
    currentWeight = meal.mealWeight;
    
    [self.mainLabel setText: object.name];
    [self prepareButtonsOnBar];
    
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    [self.mySlider setMaximumValue: [Settings sharedSingleton].maxWeight];
    self.sliderDelegate = self;
    
    if (!meal.isUserDefined) {
        [self.detailsButton setHidden:YES];
    }
    
    //[super viewDidLoad];
    
    [meal countAllNutricionFactsFor: meal.mealWeight];
    [detailsView setAllForWeight: meal.ingredientsWeight];
    
    //[[SQLiteController sharedSingleton] serializeDatabase];
}

- (IBAction)changeWeightClicked:(id)sender {
    self.changeWeightButton.selected = !self.changeWeightButton.selected;
    [self.weightSliderView setHidden: !self.changeWeightButton.selected];
    [self.weightTextField setUserInteractionEnabled: self.changeWeightButton.selected];
    //[imageBelow setHidden: !self.changeWeightButton.selected];
    
    int sizeToChange = self.changeWeightButton.frame.size.height+3;
    self.subValuesView.frame = [RectUtils rect: self.subValuesView.frame offsetYSmallerHeight: self.changeWeightButton.selected ? sizeToChange : -sizeToChange];
    
    /*
    CGRect rect = self.subValuesView.frame;
    int sizeToChange = self.changeWeightButton.frame.size.height+3;
    rect.origin.y += (self.changeWeightButton.selected ? sizeToChange : -sizeToChange);
    rect.size.height += (self.changeWeightButton.selected ? -sizeToChange : sizeToChange);
    [self.subValuesView setFrame:rect];
    
    [detailsView setFrame: CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [detailsView.nutricionFacts setFrame:CGRectMake(0, detailsView.nutricionFacts.frame.origin.y, detailsView.frame.size.width, detailsView.nutricionFacts.frame.size.height + (self.changeWeightButton.selected ? -sizeToChange : sizeToChange))];
    [detailsView.nutricionFacts setContentSize: CGSizeMake(rect.size.width, detailsView.nutricionFacts.realHeight)];
     */
}

- (NSString *) removeMe{
    NSMutableString * str = [NSMutableString stringWithString: [super removeMe]];
    [str appendFormat:@"DELETE FROM element_has_element WHERE id_parent=%d;", meal.theid];    
    return str;
}

- (void)valueChanged:(double)newVal{
    [super valueChanged: newVal];
    [detailsView setAllForWeight: newVal];
}

- (IBAction)detailsButtonClicked:(id)sender {
    IndgredientsPropertiesViewController * props = [[IndgredientsPropertiesViewController alloc] initWithNibName:@"AbstractMedtronicViewController" bundle:[NSBundle mainBundle] withInside: YES];
    
    for (Ingredient * ing in meal.ingredients) {
        [props.ingredientsView addNewElement: ing];
    }
    
    props.isInside = YES;
    [props setEditable: meal];
    
    props.changeDelegate = self;
    
    [[self myRealNavigationController] pushViewController:props animated:YES];
}

- (void)ingredientsChanged{
    NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", object.theid];
    
    meal = [[Meal alloc] initWithId: object.theid andName:object.name];
    meal = (Meal*)[[SQLiteController sharedSingleton] execSelect:sel fillObject:meal];
    
    NSArray * ingredients = [[SQLiteController sharedSingleton] getAllIngredientsFor: meal.theid];
    
    for (Ingredient * ing in ingredients) {
        [meal addIngredient: ing];
    }
    [meal countAllNutricionFactsFor: meal.mealWeight];
    detailsView.mealDish = meal;
    self.object = meal;
    currentWeight = meal.mealWeight;
    
    [self.mainLabel setText: object.name];
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    self.sliderDelegate = self;
    
    [meal countAllNutricionFactsFor: meal.mealWeight];
    
    detailsView.nutricionFacts.object = meal;
    [detailsView setAllForWeight: meal.ingredientsWeight];
}


- (void)ingredientSelected:(Ingredient *)ing{
    
    if (ing.element.type == PRODUCT) {
        DetailProductViewController * productView = [[DetailProductViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: ing.element];
        [productView valueChanged: ing.weight];
        productView.isInside = self.isInside;
        [[self myRealNavigationController] pushViewController: productView animated:YES];
    }
    else{
        /*
        DetailDishViewController * productView = [[DetailDishViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: ing.element];
        
        [productView valueChanged: ing.weight];
        productView.isInside = self.isInside;
        
        [[self myRealNavigationController] pushViewController: productView animated:YES];
        */
        
        DetailDishViewController * next = nil;
        NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", ing.element.theid];
        Dish * dish = [[Dish alloc] initWithId: ing.element.theid andName: ing.element.name];
        dish = (Dish*)[[SQLiteController sharedSingleton] execSelect: sel fillObject: dish];
        
        if (dish.weightCooked == 0) {
            next = [[DetailDishViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: dish];
        }
        else{
            next = [[DetailDishViewController alloc] initWithNibName:@"DetailDishViewController" andObject: dish];
        }
        
        next.isInside = self.isInside;
        [next valueChanged: ing.weight];
        [[self myRealNavigationController] pushViewController: next animated:YES];
    }
}

@end
