//
//  ElementsListViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ElementsListViewController.h"
#import "MedtronicObject.h"
#import "Meal.h"
#import "Dish.h"
#import "Product.h"
#import "AbstractDetailViewController.h"
#import "DetailDishViewController.h"
#import "DetailMealViewController.h"
#import "DetailProductViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "MedtronicConstants.h"

@implementation ElementsListViewController

@synthesize
mainFilter,
parentCategory,
addDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(int)thetype andMainFilter: (int) filter{
    self = [super initWithNibName:nibNameOrNil andType:thetype];
    mainFilter = filter;
    parentCategory = nil;
    addDelegate = nil;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (mainFilter == FAVOURITE) {
        UILabel * lab = (UILabel *)[noneTableViewCell viewWithTag:100];
        [lab setText: [NSString stringWithFormat: @"Nie masz jeszcze ulubionych %@", (type == DISH)? @"potraw" : (type == PRODUCT ? @"produktów" : @"posiłków")]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == noneTableViewCell && mainFilter == FAVOURITE) {
        
        UILabel * lab = (UILabel *)[noneTableViewCell viewWithTag: LABEL_TAG];
        if (searchFilter) {
            [lab setText:@"Brak wyników"];
        }
        else{
            [lab setText: [NSString stringWithFormat: @"Nie masz jeszcze ulubionych %@", (type == DISH)? @"potraw" : (type == PRODUCT ? @"produktów" : @"posiłków")]];
        }
    }
    return cell;
}

- (NSString *) getAppropriateSelect{
    
    if (parentCategory) {
        return [NSString stringWithFormat: @"SELECT id, name, is_user_defined FROM ELEMENT JOIN ELEMENT_HAS_CATEGORY ON ELEMENT.id = ELEMENT_HAS_CATEGORY.id_element WHERE ELEMENT_HAS_CATEGORY.id_category=%d ORDER BY name COLLATE NOCASE", parentCategory.theid];
    }
    
    if (type == DISH_PRODUCT) {
        return [NSString stringWithFormat: @"SELECT id, name, is_user_defined FROM ELEMENT WHERE type=%d OR type=%d ORDER BY name COLLATE NOCASE", DISH, PRODUCT];
    }
    
    switch (mainFilter) {
        case FAVOURITE:
            return [NSString stringWithFormat: @"SELECT id, name, is_user_defined FROM ELEMENT WHERE type=%d AND is_favourite=1 ORDER BY name COLLATE NOCASE", type];
            break;
            
        default: // all
            return [NSString stringWithFormat: @"SELECT id, name, is_user_defined FROM ELEMENT WHERE type=%d ORDER BY name COLLATE NOCASE", type];
            break;
    }
}

- (MedtronicObject *) getAppropriateEmptyObject{
    
    switch (type) {
        case MEAL:
            return [[Meal alloc] init];
            break;
            
        case DISH:
            return [[Dish alloc] init];
            break;
            
        default:// PRODUCT
            return [[Product alloc] init];
            break;
    }
}

- (void) objectSelected: (MedtronicObject *) obj{
    
    //Element * obj = [allData objectAtIndex: row];
    
    if (addDelegate) {
        AddIngredientWithWeightViewController * addThisOne = [[AddIngredientWithWeightViewController alloc] initWithNibName:@"AddIngredientWithWeightViewController" bundle:nil];
        [addThisOne setDelegate: addDelegate];
        addThisOne.element = (Element *)obj;
        if (self.isInside && !self.forceNotInside) {
            addThisOne.isInside = self.isInside;
        }
        [self.myStack.delegate pushControllerAbove:addThisOne withPrevious: self];
        return;
    }
    
    AbstractDetailViewController * next = nil;
    
    switch (type) {
        case MEAL:
            next = [[DetailMealViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject:obj];
            break;
            
        case DISH:{
            
            // check if it's cooked or not
            NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", obj.theid];
            Dish * dish = [[Dish alloc] initWithId: obj.theid andName: obj.name];
            dish = (Dish*)[[SQLiteController sharedSingleton] execSelect:sel fillObject: dish];
            
            if (dish.weightCooked == 0) {
                next = [[DetailDishViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject:obj];
            }
            else{
                next = [[DetailDishViewController alloc] initWithNibName:@"DetailDishViewController" andObject:obj];
            }
            
            break;
        }
            
        default:// PRODUCT
            next = [[DetailProductViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject:obj];
            break;
    }
    next.isInside = self.isInside;
    
    //MedtronicAboveNavigationController * above = [[MedtronicAboveNavigationController alloc] initWithNibName: @"MedtronicAboveNavigationController" bundle:nil];
    //above.rootView = next;
    
    //[self.myStack.delegate pushControllerAbove:above withPrevious:self];
    
    [self.myStack.delegate pushControllerAbove: next withPrevious:self];
}

- (NSString *)getCategoryLabel{
    if (parentCategory) {
        return parentCategory.name;
    }
    return @"";
}

- (void)gotNewData{
    if ([allData count] == 0 && parentCategory && parentCategory.isUserDefined) {
        if (addRow) {
            removeRowIndex = 1;
        }
        else
            removeRowIndex = 0;
    }
}

- (void)removeFromList:(id)sender{
    // usuniecie kategorii
    NSString * removeSql = [NSString stringWithFormat:@"DELETE FROM category_has_category WHERE id_child=%d; DELETE FROM category WHERE id=%d;", parentCategory.theid, parentCategory.theid];
    
    if ([[SQLiteController sharedSingleton] commitTransaction: removeSql]) {
        [self showMessage: @"Kategoria została usunięta"];
        [self.myStack popViewController];
        return;
    }
    else{
        [self showError:@"Nie udało się usunąć kategorii"];
    }
}

@end
