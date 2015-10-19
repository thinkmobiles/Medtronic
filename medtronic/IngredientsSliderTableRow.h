//
//  IngredientsSliderTableRow.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-10.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingredient.h"

@class IngredientsSliderTableRow;

@protocol IngredientsSliderTableRowDelegate <NSObject>

- (void) ingredientTableRowShowChange: (Ingredient *) row;
- (void) ingredientTableRowDelete: (Ingredient *) ing;
- (void) ingredientTableRowWeightChanged: (Ingredient *) ing;

@end


@interface IngredientsSliderTableRow : UITableViewCell <UITextFieldDelegate>{

    Ingredient * ingredient;
    BOOL hasSliderShown;
    id<IngredientsSliderTableRowDelegate> delegate;
    id<UITextFieldDelegate> textFieldDelegate;
}

@property (nonatomic, retain) Ingredient * ingredient;
@property BOOL hasSliderShown;
@property (nonatomic, retain) id<IngredientsSliderTableRowDelegate> delegate;
@property (nonatomic, retain) id<UITextFieldDelegate> textFieldDelegate;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *lineView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *gLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *weightButton;
//@property (unsafe_unretained, nonatomic) IBOutlet UILabel *weightLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *removeButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *wSlider;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *weightView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *weightTextField;
//@property (unsafe_unretained, nonatomic) IBOutlet UIImageView  *imageBelow;

- (IBAction)changeWeightClicked:(id)sender;
- (id) initWithIngredient: (Ingredient *)ing;
- (void) setSliderShown: (BOOL) set;
- (IBAction) removeIngredient: (id) sender;
- (void) setMyTextDelegate: (id<UITextFieldDelegate>) del;
- (IBAction)closeSliderClicked:(id)sender;

@end
