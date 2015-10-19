//
//  FastCreateDetailMealViewController.m
//  medtronic
//
//  Created by Apple Saturn on 12-10-12.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "FastCreateDetailMealViewController.h"
#import "FoodParametres.h"
#import "Settings.h"
#import "DetailProductViewController.h"
#import "DetailDishViewController.h"
#import "SQLiteController.h"
#import "AddMealViewController.h"
#import "IndgredientsPropertiesViewController.h"
#import "RectUtils.h"

@implementation FastCreateDetailMealViewController

- (void)viewDidLoad{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [meal countAllNutricionFactsFor: meal.mealWeight];
    
    [self setTitle:@"Nowy posiłek"];
    
    detailsView = [[NutricionFactsAndIngredientsView alloc] initWithFrame:CGRectMake(0, 0, self.subValuesView.frame.size.width, self.subValuesView.frame.size.height) andElement: meal];
    detailsView.delegate = self;
    detailsView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.subValuesView addSubview: detailsView];
    
    currentWeight = meal.mealWeight;
    
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    [self.mySlider setMaximumValue: [Settings sharedSingleton].maxWeight];
    self.sliderDelegate = self;
    
   [self.detailsButton setHidden:NO];
    
    //[super viewDidLoad];
    
    [meal countAllNutricionFactsFor: meal.mealWeight];
    [detailsView setAllForWeight: meal.ingredientsWeight];
    
    // save it
    UIButton * realAdd = [self createNavigationBarButton:@"Zakończ"];
    [realAdd addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:realAdd];
    [[self myRealNavigationItem] setRightBarButtonItem: item];
}

- (void)okAdd:(id)sender{
 
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddMealController" owner:nil options:nil];
    UINavigationController * navController = [arr objectAtIndex:0];
    AddMealViewController * addMeal = [[navController viewControllers] objectAtIndex:0];

    [self presentViewController:navController animated:YES completion:^{
        for (Ingredient * ing in meal.ingredients) {
            [addMeal ingredientToAdd: ing];
        }
    }];
}

- (void)cancel:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion: nil];
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
    return @"";
}

- (void)valueChanged:(double)newVal{
    [super valueChanged: newVal];
    [detailsView setAllForWeight: newVal];
}

- (IBAction) detailsButtonClicked:(id)sender {
        
    IndgredientsPropertiesViewController * props = [[IndgredientsPropertiesViewController alloc] initWithNibName:@"AbstractMedtronicViewController" bundle:[NSBundle mainBundle] withInside: NO];
    
    for (Ingredient * ing in meal.ingredients) {
        [props.ingredientsView addNewElement: ing];
    }
    
    //props.isInside = NO;
    //[props setEditable: meal];
    //props.changeDelegate = self;
    props.ingredientsDelegate = self;
    
    [[self myRealNavigationController] pushViewController:props animated:YES];
}

- (void)ingredientsChanged{
    
}

- (void) showDetails: (NSMutableArray *) ings{

}

- (void) detailsDismiss: (NSMutableArray *) ings{
    
    [meal.ingredients removeAllObjects];
    meal.ingredientsWeight = 0.0f;
    for (Ingredient * ing in ings) {
        [meal addIngredient: ing];
    }
    meal.mealWeight = meal.ingredientsWeight;
    [meal countAllNutricionFactsFor: meal.mealWeight];
    
    detailsView.mealDish = meal;
    self.object = meal;
    currentWeight = meal.mealWeight;
    
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

- (void)viewDidUnload {
    [self setSaveMealButton:nil];
    [super viewDidUnload];
}
@end
