//
//  DetailMealViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "AbstractDetailViewController.h"
#import "NutricionFactsAndIngredientsView.h"
#import "Meal.h"
#import "IngredientsView.h"

@interface DetailMealViewController : AbstractDetailViewController
<NutricionFactsAndIngredientsViewDelegate, IngredientsChangeDelegate>{

    NutricionFactsAndIngredientsView * detailsView;
    Meal * meal;
}

@property (nonatomic, retain) Meal * meal;

@end