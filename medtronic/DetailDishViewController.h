//
//  DetailDishViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "AbstractDetailViewController.h"
#import "Dish.h"
#import "NutricionFactsAndIngredientsView.h"
#import "IngredientsView.h"

@interface DetailDishViewController : AbstractDetailViewController
<NutricionFactsAndIngredientsViewDelegate, IngredientsChangeDelegate>{
    Dish * dish;
    NutricionFactsAndIngredientsView * detailsView;
    float dishFactor;
}

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *dishCookedButton;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *rawIngredientsWeight;

@property (nonatomic, retain) Dish * dish;

- (IBAction)dishCookedButtonClicked:(id)sender;

@end
