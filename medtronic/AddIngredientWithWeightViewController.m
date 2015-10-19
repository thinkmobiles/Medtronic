//
//  AddIngredientWithWeightViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AddIngredientWithWeightViewController.h"
#import "FoodParametres.h"
#import "Settings.h"

@implementation AddIngredientWithWeightViewController
@synthesize nameLabel;
@synthesize weightTextField,
element,
delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    inToAdd = [[Ingredient alloc] initWithWeight: 100.0f andElement: element];
    [self.mySlider setValue: 100.0f];
    [self.mySlider setMaximumValue: [Settings sharedSingleton].maxWeight];
    [weightTextField setText: [FoodParametres doubleString:100.0f]];
    
    [self addOkButton];
    
    [self.weightTextField setDelegate:self];
    [self setTitle:@"Dodaj składnik"];
    [self.nameLabel setText: element.name];
    
    self.sliderDelegate = self;
}

- (void)viewDidUnload{
    [self setNameLabel:nil];
    [self setWeightTextField:nil];
    [super viewDidUnload];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    double newVal = [[textField text] doubleValue];
    [self.mySlider setValue: (float)newVal animated:YES];
}

- (void)okAdd:(id)sender{
    double newVal = [[weightTextField text] doubleValue];
    [inToAdd setWeight: newVal];
    [inToAdd setAllParametres];
    
    [self dismissKeyboard];
    [self.delegate ingredientToAdd: inToAdd];
    
    NSArray * arr = [self.navigationController viewControllers];
    UIViewController * preView = [arr objectAtIndex: [arr count]-3];
    
    [self.navigationController popToViewController:preView animated:YES];
}

- (void)valueChanged:(double)newVal{
    [self.weightTextField setText: [FoodParametres doubleString: newVal]];
}

@end
