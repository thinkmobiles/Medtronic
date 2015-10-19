//
//  AbstractDetailViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "Element.h"
#import "NutricionFactsView.h"
#import "Ingredient.h"

@interface AbstractDetailViewController : AbstractMedtronicViewController
<UIAlertViewDelegate, UISliderDelegate>{
    Element * object;
    double currentWeight;
    //Ingredient * ingredient;
    
    UIButton * favouriteButton;
    UIButton * removeButton;
    
    NutricionFactsView * valuesView;
}

@property (nonatomic, retain) Element * object;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView * subValuesView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *changeWeightButton;
//@property (unsafe_unretained, nonatomic) IBOutlet UILabel *weightLabel;
//@property (nonatomic, retain) Ingredient * ingredient;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *detailsButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *weightSliderView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *weightTextField;
//@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageBelow;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *itdWeightLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *notEditableImage;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *notEditableLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil andObject: (MedtronicObject*) obj;

- (IBAction)detailsButtonClicked:(id)sender;
- (IBAction)closeSliderClicked:(id)sender;

- (IBAction)changeWeightClicked:(id)sender;
- (IBAction)addToFav:(id)sender;
- (void) prepareButtonsOnBar;
- (IBAction)removeElement:(id)sender;
- (NSString *) checkIfCanDelete;
- (NSString *) removeMe;

@end
