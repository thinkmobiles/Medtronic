//
//  FastCreateDetailDishViewController.m
//  medtronic
//
//  Created by LooksoftHD on 16.10.2012.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "FastCreateDetailDishViewController.h"
#import "Settings.h"
#import "FoodParametres.h"
#import "IndgredientsPropertiesViewController.h"
#import "DetailProductViewController.h"
#import "AddDishViewController.h"

@implementation FastCreateDetailDishViewController

- (void)viewDidLoad{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [dish countAllNutricionFactsFor: dish.ingredientsWeight fromSuper:YES];
    //[dish countAllNutricionFactsFor: dish.ingredientsWeight*dish.weightChangeFactor];
    
    //NSLog(@"dish: %d %f", [dish.ingredients count], dish.ingredientsWeight);
    
    [self setTitle:@"Nowa potrawa"];
    
    detailsView = [[NutricionFactsAndIngredientsView alloc] initWithFrame:CGRectMake(0, 0, self.subValuesView.frame.size.width, self.subValuesView.frame.size.height) andElement: dish];
    detailsView.delegate = self;
    detailsView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.subValuesView addSubview: detailsView];
    
    self.object = dish;
    
//    NSLog(@"Dish weight: %f weightChange: %f", dish.ingredientsWeight, dish.weightChangeFactor);
    
    //[self.mainLabel setText: object.name];
    //[self prepareButtonsOnBar];
    currentWeight = dish.ingredientsWeight/dish.weightChangeFactor;
    
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    [self.mySlider setMaximumValue: [Settings sharedSingleton].maxWeight];
    self.sliderDelegate = self;
    
    if (self.rawIngredientsWeight) {
        [self.rawIngredientsWeight setText: [FoodParametres doubleString: currentWeight*dish.weightChangeFactor]];
    }
    [detailsView setAllForWeight: currentWeight*dish.weightChangeFactor];
    
    // save it
    UIButton * realAdd = [self createNavigationBarButton:@"Zakończ"];
    [realAdd addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:realAdd];
    [[self myRealNavigationItem] setRightBarButtonItem: item];
}

- (void)okAdd:(id)sender{
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddDishController" owner:nil options:nil];
    UINavigationController * navController = [arr objectAtIndex:0];
    AddDishViewController * addMeal = [[navController viewControllers] objectAtIndex:0];
    
    if (dish.weightChangeFactor != 1.0f) {
        addMeal.weightAfter = [[self.weightTextField text] floatValue];
    }
    
    addMeal.alreadyPrepared = YES;
    
    [self presentViewController:navController animated:YES completion:^{
        for (Ingredient * ing in dish.ingredients) {
            [addMeal ingredientToAdd: ing];
        }
    }];
}

- (void)cancel:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion: nil];
}
/*
- (IBAction)changeWeightClicked:(id)sender {
    self.changeWeightButton.selected = !self.changeWeightButton.selected;
    [self.weightSliderView setHidden: !self.changeWeightButton.selected];
    [self.weightTextField setUserInteractionEnabled: self.changeWeightButton.selected];
    //[imageBelow setHidden: !self.changeWeightButton.selected];
    
    CGRect rect = self.subValuesView.frame;
    int sizeToChange = self.changeWeightButton.frame.size.height+3;
    rect.origin.y += (self.changeWeightButton.selected ? sizeToChange : -sizeToChange);
    rect.size.height += (self.changeWeightButton.selected ? -sizeToChange : sizeToChange);
    [self.subValuesView setFrame:rect];
    
    [detailsView setFrame: CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [detailsView.nutricionFacts setFrame:CGRectMake(0, detailsView.nutricionFacts.frame.origin.y, detailsView.frame.size.width, detailsView.nutricionFacts.frame.size.height + (self.changeWeightButton.selected ? -sizeToChange : sizeToChange))];
    [detailsView.nutricionFacts setContentSize: CGSizeMake(rect.size.width, detailsView.nutricionFacts.realHeight)];
}*/

- (NSString *) removeMe{
    return @"";
}

- (IBAction) detailsButtonClicked:(id)sender {
    
    IndgredientsPropertiesViewController * props = [[IndgredientsPropertiesViewController alloc] initWithNibName:@"AbstractMedtronicViewController" bundle:[NSBundle mainBundle] withInside: NO];
    
    for (Ingredient * ing in dish.ingredients) {
        [props.ingredientsView addNewElement: ing];
    }
    
    props.ingredientsDelegate = self;
    [[self myRealNavigationController] pushViewController:props animated:YES];
}

- (void)ingredientsChanged{
}

- (void) showDetails: (NSMutableArray *) ings{
}

- (void) detailsDismiss: (NSMutableArray *) ings{
    
    [dish.ingredients removeAllObjects];
    dish.ingredientsWeight = 0.0f;
    
    for (Ingredient * ing in ings) {
        [dish addIngredient: ing];
    }
    //meal.mealWeight = meal.ingredientsWeight;
    [dish countAllNutricionFactsFor: dish.ingredientsWeight fromSuper:YES];
    
    detailsView.mealDish = dish;
    self.object = dish;
    currentWeight = dish.ingredientsWeight;
    
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    self.sliderDelegate = self;
    
    //[dish countAllNutricionFactsFor: dish.ingredientsWeight];
    
    detailsView.nutricionFacts.object = dish;
    [detailsView setAllForWeight: dish.ingredientsWeight];
    
    if (self.rawIngredientsWeight) {
        [self.rawIngredientsWeight setText: [FoodParametres doubleString: dish.ingredientsWeight]];
    }
}

- (void)ingredientSelected:(Ingredient *)ing{
    
    if (ing.element.type == PRODUCT) {
        DetailProductViewController * productView = [[DetailProductViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: ing.element];
        [productView valueChanged: ing.weight];
        productView.isInside = self.isInside;
        [[self myRealNavigationController] pushViewController: productView animated:YES];
    }
}

@end
