//
//  AbstractAddElementViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-02.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "ChooseCategoriesViewController.h"
#import "IndgredientsPropertiesViewController.h"
#import "IngredientsView.h"
#import "AddIngredientWithWeightViewController.h"

@class MedtronicAboveNavigationController;
@class AbstractMedtronicChooseElementController;

@interface AbstractAddElementViewController : AbstractMedtronicViewController
<CategoriesSelectionDelegate, AddIngredientWithWeightDelegate, IngredientsViewDelegate, UITextFieldDelegate>{
    
    NSMutableArray * catsChosen;
    ChooseCategoriesViewController * catsView;
    MedtronicAboveNavigationController * categoriesController;
    
    IngredientsView * ingredientsTable;
    AbstractMedtronicChooseElementController * mealIngsView;
}

@property (nonatomic, retain) IngredientsView * ingredientsTable;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameText;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *chooseCategoryButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *addElementButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *categoryLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *lastLine;

- (IBAction)chooseCategory:(id)sender;
- (IBAction)addElement:(id)sender;


@end
