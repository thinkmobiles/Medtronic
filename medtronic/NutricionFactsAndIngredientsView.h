//
//  NutricionFactsAndIngredientsView.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-05.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButtonsGroup.h"
#import "Element.h"
#import "NutricionFactsView.h"
#import "MealDish.h"

@protocol NutricionFactsAndIngredientsViewDelegate <NSObject>

- (void) ingredientSelected: (Ingredient *) ing;

@end


@interface NutricionFactsAndIngredientsView : UIView
<UITableViewDelegate, UITableViewDataSource, RadioButtonsGroupDelegate>{

    NutricionFactsView * nutricionFacts;
    RadioButtonsGroup * buttonsExclusive;
    
    //Ingredient * ingredient;
    MealDish * mealDish;
    //NSArray * ingredients; 
    
    id<NutricionFactsAndIngredientsViewDelegate> delegate;
}

@property (nonatomic, retain) id<NutricionFactsAndIngredientsViewDelegate> delegate;
//@property (nonatomic, retain) Ingredient * ingredient;
@property (nonatomic, retain) MealDish * mealDish;
@property (nonatomic, retain) NutricionFactsView * nutricionFacts;

@property (strong, nonatomic) IBOutlet UIView *allView;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *ingredientsTable;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *nutricionButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ingredientsButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *subView;
//@property (nonatomic, retain) NSArray * ingredients;

- (id)initWithFrame:(CGRect)frame andElement: (MealDish *) el;
- (void) setAllForWeight: (double) newW;

@end
