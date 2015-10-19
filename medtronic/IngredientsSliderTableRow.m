//
//  IngredientsSliderTableRow.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-10.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "IngredientsSliderTableRow.h"
#import "Ingredient.h"
#import "FoodParametres.h"
#import "Settings.h"

@implementation IngredientsSliderTableRow
@synthesize lineView;
@synthesize mainLabel;
@synthesize gLabel;
@synthesize weightButton;
//@synthesize weightLabel;
@synthesize removeButton;
@synthesize wSlider;
@synthesize weightView;
@synthesize weightTextField;

@synthesize
hasSliderShown,
ingredient,
delegate,
textFieldDelegate;


- (id) initWithIngredient: (Ingredient *)ing{
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 36)];
    
    [[NSBundle mainBundle] loadNibNamed:@"IngredientSliderTableRow" owner:self options:nil];
    
    self.ingredient = ing;
    
    [self addSubview: lineView];
    [self addSubview: mainLabel];
    [self addSubview: weightView];
    [self addSubview:weightButton];
    //[self addSubview: imageBelow];
    [self addSubview:removeButton];
    [self addSubview:gLabel];
    [self addSubview: weightTextField];
    
    
    hasSliderShown = NO;
    [weightView setHidden: YES];
    weightButton.selected = NO;
    
    [weightTextField setText: [FoodParametres doubleString: ingredient.weight]];
    //[weightLabel setText: [Utils doubleString: ingredient.weight]];
    
    [wSlider setMaximumValue: [Settings sharedSingleton].maxWeight];
    wSlider.value = ingredient.weight;
    //[imageBelow setHidden:YES];
    
    return self;
}

- (void)setIngredient:(Ingredient *)ing{
    ingredient = ing;
    [weightTextField setText: [FoodParametres doubleString: ing.weight]];
    [mainLabel setText: ing.element.name];
    //[weightLabel setText: [Utils doubleString: ing.weight]];
}

- (void) setSliderShown: (BOOL) set{
    hasSliderShown = set;
    [weightView setHidden: !set];
    weightButton.selected = set;
    [weightTextField setUserInteractionEnabled: set];
    //[imageBelow setHidden: !set];
    [removeButton setHidden: set];
}

- (void) setMyTextDelegate: (id<UITextFieldDelegate>) del{
    textFieldDelegate = del;
    //weightTextField.delegate = del;
}

- (IBAction)closeSliderClicked:(id)sender {
    [self setSliderShown:NO];
    [delegate ingredientTableRowShowChange: hasSliderShown ? ingredient : nil];
}

- (IBAction)changeWeightClicked:(id)sender {
    [self setSliderShown: !hasSliderShown];
    [delegate ingredientTableRowShowChange: hasSliderShown ? ingredient : nil];
}

- (IBAction)slidersValueChanged:(id)sender {
    
    double val = (int)(wSlider.value + 0.5f);
    if (val < 0.1f) {
        val = 0.1f;
        wSlider.value = 0.1f;
    }
    
    [ingredient setWeight: val];
    [ingredient setAllParametres];
    [delegate ingredientTableRowWeightChanged: ingredient];
    [weightTextField setText: [FoodParametres doubleString: val]];
}

- (IBAction)sliderDraggedInside:(id)sender {    
    double val = (int)(wSlider.value + 0.5f);
    
    if (val < 0.1f) {
        val = 0.1f;
        wSlider.value = 0.1f;
    }
    
    [ingredient setWeight: val];
    [ingredient setAllParametres];
    [delegate ingredientTableRowWeightChanged: ingredient];
    [weightTextField setText: [FoodParametres doubleString: val]];
}

- (IBAction) removeIngredient: (id) sender{
    [delegate ingredientTableRowDelete: ingredient];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //[textFieldDelegate textFieldDidEndEditing: textField];
    double value = [[textField text] doubleValue];
    [[self wSlider] setValue: value animated:YES];
    [ingredient setWeight: value];
    [ingredient setAllParametres];
    [delegate ingredientTableRowWeightChanged: ingredient];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textFieldDelegate textFieldShouldReturn: textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textFieldDelegate textFieldDidBeginEditing: textField];
}


@end
