//
//  IngredientsView.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingredient.h"
#import "Element.h"
#import "IngredientsSliderTableRow.h"

@class IngredientsView;

@protocol IngredientsViewDelegate <NSObject>

- (void) showDetails: (NSMutableArray *) ings;
- (void) detailsDismiss: (NSMutableArray *) ings;

@end

@protocol IngredientsChangeDelegate <NSObject>

- (void) ingredientsChanged;

@end

typedef struct {
    double kcal;
    double ww;
    double wbt;
} Properties;

@interface IngredientsView : UIView
<UITableViewDelegate, UITableViewDataSource, IngredientsSliderTableRowDelegate>{

    NSMutableArray * ingredients;
    NSMutableDictionary * tableRows;
    Ingredient * currentChangeIngredient;
    
    id<UITextFieldDelegate> textFieldDelegate;
    
    id<IngredientsViewDelegate> delegate;
    id<IngredientsChangeDelegate> changeDelegate;
    
    double allFibreValue;
    double allFatValue;
    double allCarbsValue;
    double allProteinValue;
    
    Properties proteinValue;
    Properties fatValue;
    Properties twoValue;
    Properties carbsValue;
    Properties allValue;
    
    
    BOOL detailed;
}

@property (nonatomic, retain) Ingredient * currentChangeIngredient;

@property Properties proteinValue;
@property Properties fatValue;
@property Properties carbsValue;
@property Properties allValue;

@property double allFibreValue;
@property double allFatValue;
@property double allCarbsValue;
@property double allProteinValue;


@property (nonatomic, retain) id<IngredientsViewDelegate> delegate;
@property (nonatomic, retain) id<IngredientsChangeDelegate> changeDelegate;

@property (nonatomic, retain) id<UITextFieldDelegate> textFieldDelegate;

@property (nonatomic, retain) NSMutableArray * ingredients;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *table;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *allInfoView;

- (id)initDetailsWithFrame:(CGRect)frame;
- (id)initOnlyDetailsWithFrame:(CGRect)frame;

- (void) initAllValues;
- (void) countForAllIngredients;

- (void) addNewElement: (Ingredient *) el;
- (IBAction) removeIngredient: (id) sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *detaildButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *detailsView;

- (IBAction)showDetailsClicked:(id)sender;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *allKcal;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *allWW;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *allWBT;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *allFibre;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *proteinKcal;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *proteinWW;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *proteinWBT;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fatKcal;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fatWW;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fatWBT;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *twoKcal;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *twoWW;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *twoWBT;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *carbsKcal;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *carbsWW;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *carbsWBT;


@end
