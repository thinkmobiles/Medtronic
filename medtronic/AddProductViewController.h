//
//  AddProductViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

//#import "AbstractMedtronicViewController.h"
#import "ChooseCategoriesViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "Settings.h"
#import "Product.h"
#import "AddProductDelegate.h"

@class AbstractMedtronicViewController;

@interface AddProductViewController : AbstractMedtronicViewController
<CategoriesSelectionDelegate>
{
    ChooseCategoriesViewController * catsView;
    Category * catChosen;
    MedtronicAboveNavigationController * above;
    
    id<AddProductDelegate> addProdDelegate;
    
    // whether calories calculations were already rechecked by the user
    BOOL caloriesRechecked;
}

@property (nonatomic, retain) id<AddProductDelegate> addProdDelegate;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameText;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *chooseCategoryButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *categoryLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *kcalText;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *proteinText;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *fatText;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *carbsText;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *fibreText;

- (IBAction)chooseCategoryClicked:(id)sender;
- (NSString *) validate;
- (void) finalAddProduct;

@end
