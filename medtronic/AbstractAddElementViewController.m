//
//  AbstractAddElementViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-02.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractAddElementViewController.h"
#import "MealIngredientsViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "IngredientsView.h"
#import "AbstractMedtronicChooseElementController.h"
#import "MedtronicConstants.h"

@implementation AbstractAddElementViewController

@synthesize 
nameText,
chooseCategoryButton,
addElementButton,
categoryLabel,
lastLine, ingredientsTable;


- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self addOkButton];
    [self addCancelButton];
    
    catsChosen = [[NSMutableArray alloc] init];
    
    catsView = [[ChooseCategoriesViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType:MEAL];
    catsView.howMany = 1;
    [catsView setDelegate: self];
    
    categoriesController = [[MedtronicAboveNavigationController alloc] initWithNibName:@"MedtronicAboveNavigationController" bundle:nil];
    categoriesController.rootView = catsView;
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        ingredientsTable = [[IngredientsView alloc] initWithFrame:
                            CGRectMake(0,
                                       self.lastLine.frame.origin.y+self.lastLine.frame.size.height,
                                       self.view.frame.size.width, self.view.frame.size.height-(self.lastLine.frame.origin.y+self.lastLine.frame.size.height)-44-19)];
    }
    else{
        ingredientsTable = [[IngredientsView alloc] initWithFrame:
                            CGRectMake(0,
                                       self.lastLine.frame.origin.y+self.lastLine.frame.size.height,
                                       self.view.frame.size.width, self.view.frame.size.height-(self.lastLine.frame.origin.y+self.lastLine.frame.size.height)-44)];
    }
    
    
    [ingredientsTable setTextFieldDelegate: self];
    ingredientsTable.delegate = self;
    
    [self.view addSubview: ingredientsTable];
}

- (void)viewDidUnload {
    [self setNameText:nil];
    [self setChooseCategoryButton:nil];
    [self setAddElementButton:nil];
    
    [super viewDidUnload];
}


- (IBAction)chooseCategory:(id)sender {
    
    catsView.preChosenCategories = catsChosen;
    
    [self.navigationController pushViewController: categoriesController animated:YES];
    [categoriesController setTitle: catsView.title];
    
    [catsView addOkButton];
}

- (IBAction)addElement:(id)sender {
    if (!mealIngsView) {
        mealIngsView = [[MealIngredientsViewController alloc] initWithNibName:@"AbstractMedtronicExclusiveButtonsController" bundle:nil];
        mealIngsView.addDelegate = self;
        [mealIngsView setTitle:@"Dodaj składnik"];
    }
    [self.navigationController pushViewController: mealIngsView animated:YES];
}


- (void)cancel:(id)sender{
    //[self showTabBar];
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)chosenCategories:(NSArray *)chosen{
    
    if ([chosen count] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSMutableString * categoriesStr = [[NSMutableString alloc] initWithFormat:@""];
    for (Category * cat in chosen) {
        //NSLog(@"Kat: %@", cat.name);
        [categoriesStr appendFormat:@"%@, ", cat.name];
    }
    [categoryLabel setText: [categoriesStr substringToIndex: [categoriesStr length]-2] ];
    
    catsChosen = [NSMutableArray arrayWithArray: chosen];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)ingredientToAdd:(Ingredient *)newOne{
    [ingredientsTable addNewElement: newOne];
    mealIngsView = nil;
}

- (void)showDetails:(NSMutableArray *)ings{
    IndgredientsPropertiesViewController * props = [[IndgredientsPropertiesViewController alloc] initWithNibName:@"AbstractMedtronicViewController" bundle:nil];
    props.ingredientsToLoad = ingredientsTable.ingredients;
    
    [self.navigationController pushViewController: props animated:YES];
//    for (Ingredient * ing in ingredientsTable.ingredients) {
//        [props.ingredientsView addNewElement: ing];
//    }
    props.ingredientsDelegate = self;
}

- (void)detailsDismiss:(NSMutableArray *)ings{
    
    [ingredientsTable.ingredients removeAllObjects];
    
    for (Ingredient * ing in ings) {
        [ingredientsTable addNewElement: ing];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [Utils textField:textField shouldChangeCharactersInRange:range replacementString:string withMaximumLimit: MAX_ELEMENT_NAME_LIMIT];
}


@end
