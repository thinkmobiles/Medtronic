//
//  DetailDishViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "DetailDishViewController.h"
#import "SQLiteController.h"
#import "IndgredientsPropertiesViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "FoodParametres.h"
#import "DetailProductViewController.h"
#import "FoodParametres.h"
#import "Settings.h"
#import "RectUtils.h"

@implementation DetailDishViewController

@synthesize dishCookedButton;
@synthesize rawIngredientsWeight, dish;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", object.theid];
    
    dish = [[Dish alloc] initWithId: object.theid andName:object.name];
    dish = (Dish*)[[SQLiteController sharedSingleton] execSelect:sel fillObject: dish];
    
    NSArray * ingredients = [[SQLiteController sharedSingleton] getAllIngredientsFor: dish.theid];
    
    for (Ingredient * ing in ingredients) {
        [dish addIngredient: ing];
    }
    [dish countAllNutricionFactsFor: dish.ingredientsWeight];
    [dish countAllNutricionFactsFor: dish.ingredientsWeight*dish.weightChangeFactor];
    
    [self setTitle:@"Potrawy"];
    
    if (dish.weightCooked > 0) {
        self.subValuesView.frame = CGRectMake(0, self.subValuesView.frame.origin.y, self.subValuesView.frame.size.width, [Utils isiPhone5] ? 291 : (291-88));
    }
    else{
        self.subValuesView.frame = CGRectMake(0, self.subValuesView.frame.origin.y, self.subValuesView.frame.size.width, [Utils isiPhone5] ? 311 : (311-88));
    }
    
    detailsView = [[NutricionFactsAndIngredientsView alloc] initWithFrame: self.subValuesView.bounds andElement: dish];
    detailsView.delegate = self;
    detailsView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.subValuesView addSubview: detailsView];
//    [self.view addSubview: detailsView];
    
    self.object = dish;
    currentWeight = dish.ingredientsWeight/dish.weightChangeFactor;
    
    [self.mainLabel setText: object.name];
    [self prepareButtonsOnBar];
    
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    
    
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    [self.mySlider setMaximumValue: [Settings sharedSingleton].maxWeight];
    self.sliderDelegate = self;
    
    if (!dish.isUserDefined) {
        [self.detailsButton setHidden:YES];
        [self.itdWeightLabel setText:@"Waga gotowej potrawy:"];
        [self.notEditableImage setHidden:NO];
        [self.notEditableLabel setHidden:NO];
        [self.mainLabel setFrame:CGRectMake(self.mainLabel.frame.origin.x, self.mainLabel.frame.origin.y, self.mainLabel.frame.size.width-125.0f, self.mainLabel.frame.size.height)];
    }
    
    //[dish countAllNutricionFactsFor: dish.ingredientsWeight];
    [detailsView setAllForWeight: dish.ingredientsWeight];
    if (rawIngredientsWeight) {
        [rawIngredientsWeight setText: [FoodParametres doubleString: dish.ingredientsWeight]];
    }
    
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
    [detailsView setFrame: CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [detailsView.nutricionFacts setFrame:CGRectMake(0, detailsView.nutricionFacts.frame.origin.y, detailsView.frame.size.width, detailsView.nutricionFacts.frame.size.height + (self.changeWeightButton.selected ? -sizeToChange : sizeToChange))];
    [detailsView.nutricionFacts setContentSize: CGSizeMake(rect.size.width, detailsView.nutricionFacts.realHeight)];
     */
}

- (void)valueChanged:(double)newVal{
    
    currentWeight = newVal;
    [self.weightTextField setText: [FoodParametres doubleString: newVal]];
    
    if (rawIngredientsWeight) {
        [self.rawIngredientsWeight setText: [FoodParametres doubleString: newVal*dish.weightChangeFactor]];
    }
    [detailsView setAllForWeight: newVal*dish.weightChangeFactor];
}

- (NSString *) removeMe{
    NSMutableString * str = [NSMutableString stringWithString: [super removeMe]];
    [str appendFormat:@"DELETE FROM element_has_element WHERE id_parent=%d;", dish.theid];    
    return str;
}

- (IBAction)detailsButtonClicked:(id)sender {
    IndgredientsPropertiesViewController * props = [[IndgredientsPropertiesViewController alloc] initWithNibName:@"AbstractMedtronicViewController" bundle:[NSBundle mainBundle] withInside: YES];
    
    //props.ingredientsDelegate = self;
    props.isInside = YES;
    [props setEditable: dish];
    
    [[self myRealNavigationController] pushViewController:props animated:YES];
    
    props.changeDelegate = self;
}

- (void)ingredientSelected:(Ingredient *)ing{
    DetailProductViewController * productView = [[DetailProductViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: ing.element];
    [productView valueChanged: ing.weight];
    productView.isInside = self.isInside;
    [[self myRealNavigationController] pushViewController: productView animated:YES];
}

- (void)viewDidUnload {
    [self setDishCookedButton:nil];
    [super viewDidUnload];
}

- (IBAction)dishCookedButtonClicked:(id)sender {
    [self showMessage:@"Potrawa po obróbce termicznej. Indeks glikemiczny gotowej potrawy może się różnić od indeksu składników."];
}

- (void)ingredientsChanged{  
    NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", object.theid];
    
    dish = [[Dish alloc] initWithId: object.theid andName:object.name];
    dish = (Dish*)[[SQLiteController sharedSingleton] execSelect:sel fillObject: dish];
    
    NSArray * ingredients = [[SQLiteController sharedSingleton] getAllIngredientsFor: dish.theid];
    
    for (Ingredient * ing in ingredients) {
        [dish addIngredient: ing];
        //NSLog(@"ing weight: %f", ing.weight);
    }
    [dish countAllNutricionFactsFor: dish.ingredientsWeight];
    [dish countAllNutricionFactsFor: dish.ingredientsWeight*dish.weightChangeFactor];
    
    self.object = dish;
    currentWeight = dish.ingredientsWeight/dish.weightChangeFactor;
    
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    
    detailsView.mealDish = dish;
    detailsView.nutricionFacts.object = dish;
    [detailsView setAllForWeight: dish.ingredientsWeight];
    
    if (rawIngredientsWeight) {
        [rawIngredientsWeight setText: [FoodParametres doubleString: dish.ingredientsWeight]];
    }
}

@end
