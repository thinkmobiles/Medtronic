//
//  WeightCookedViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-03.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "IngredientsView.h"
#import "AddDishViewController.h"
#import "Dish.h"

@interface WeightCookedViewController : AbstractMedtronicViewController
<UISliderDelegate>{

    NSString * name;
    NSArray * categories;
    NSMutableArray * ingredients;
    
    IngredientsView * ings;
    double weightBefore;
    
    Dish * dishToEdit;
    
    id<AddDishDelegate> addDishDelegate;
    BOOL fastCreate;
}

@property (nonatomic, retain) id<AddDishDelegate> addDishDelegate;
@property (nonatomic, assign) id<IngredientsChangeDelegate> changeDelegate;

@property (nonatomic, retain) Dish * dishToEdit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSArray * categories;
@property (nonatomic, retain) NSMutableArray * ingredients;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *ingredientsWieghtLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *afterWeightTextbox;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *subView;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *infoLabel;

@property BOOL fastCreate;

@end
