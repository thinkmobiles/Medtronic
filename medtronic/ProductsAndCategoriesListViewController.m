//
//  ProductsAndCategoriesListViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ProductsAndCategoriesListViewController.h"
#import "Category.h"
#import "Product.h"
#import "DetailProductViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "AddCategoryViewController.h"
#import "AbstractMedtronicViewController.h"
#import "MedtronicConstants.h"

@implementation ProductsAndCategoriesListViewController

@synthesize
depth;
//mainFilter;


- (id)initWithNibName:(NSString *)nibNameOrNil andType:(int)thetype andMainFilter: (int) filter{
    self = [super initWithNibName:nibNameOrNil andType:thetype];
    mainFilter = filter;
    parentCategory = nil;
    depth = -1;
    gettingProducts = NO;
    //addDelegate = nil;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (depth <= 3) {
        addRow = YES;
    }
}

- (NSString *) getAppropriateSelect{
    gettingProducts = NO;
    
    if (parentCategory) {
        
        NSString * sel = [NSString stringWithFormat: @"SELECT * FROM CATEGORY JOIN CATEGORY_HAS_CATEGORY ON CATEGORY.id = CATEGORY_HAS_CATEGORY.id_child WHERE CATEGORY.type=%d AND CATEGORY_HAS_CATEGORY.id_parent=%d ORDER BY name COLLATE NOCASE", type, parentCategory.theid];
        return sel;
    }
    
    return [NSString stringWithFormat: @"SELECT * FROM CATEGORY WHERE type=%d AND depth=%d ORDER BY %@ COLLATE NOCASE", type, depth, @"name"];
}


- (MedtronicObject *) getAppropriateEmptyObject{
    return [[Category alloc] init];
}



- (void) objectSelected:(MedtronicObject *)obj{
    
    //MedtronicObject * obj = [allData objectAtIndex: row];
    
    if ([obj isKindOfClass:[Category class]]) {
        // category
        // let's go deeper
        
        ProductsAndCategoriesListViewController * next = [[ProductsAndCategoriesListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType:type andMainFilter:mainFilter];
        next.parentCategory = (Category *) obj;
        next.depth = depth+1;
        next.isInside = isInside;
        next.forceNotInside = forceNotInside;
        next.addDelegate = addDelegate;
        [self.myStack pushViewController: next withPrevious:self];
    }
    else{
        // element
        
        if (addDelegate) {
            AddIngredientWithWeightViewController * addThisOne = [[AddIngredientWithWeightViewController alloc] initWithNibName:@"AddIngredientWithWeightViewController" bundle:nil];
            [addThisOne setDelegate: addDelegate];
            addThisOne.element = (Element*)obj;
            if (self.isInside && !self.forceNotInside) {
                addThisOne.isInside = self.isInside;
            }
            [self.myStack.delegate pushControllerAbove:addThisOne withPrevious: self];
            return;
        }
        
        DetailProductViewController * next = [[DetailProductViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject:obj];
        next.isInside = isInside;
        next.forceNotInside = forceNotInside;
        [self.myStack.delegate pushControllerAbove: next withPrevious:self];
    }   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == addTableViewCell || cell == noneTableViewCell || cell == removeTableViewCell) {
        return cell;
    }
    int index = [indexPath row];
    if (addRow) {
        index -= 1;
    }
    if ([allData count] <= index) {
        return cell;
    }
    
    MedtronicObject * obj = [allData objectAtIndex: index];
    
    UILabel * label = (UILabel *)[cell viewWithTag: LABEL_TAG];
    if ([obj isKindOfClass:[Category class]]) {
        [label setTextColor: [UIColor blackColor]];
    }
    
    return cell;
}


- (NSString *) getAppropriateProductsSelect{
    gettingProducts = YES;
    
    return [NSString stringWithFormat: @"SELECT id, name FROM ELEMENT JOIN ELEMENT_HAS_CATEGORY ON ELEMENT.id = ELEMENT_HAS_CATEGORY.id_element WHERE ELEMENT_HAS_CATEGORY.id_category=%d ORDER BY name COLLATE NOCASE", parentCategory.theid];
}

- (void) getProductsToShow{
    
    NSString * query = [self getAppropriateProductsSelect];
    MedtronicObject * obj = [[Product alloc] init];
    [[SQLiteController sharedSingleton] execSelect: query getObjectsLike:obj for: self];
}


- (void)didReceiveArray:(NSMutableArray *)arr{
    
    if (!gettingProducts) {
        // so we have to get them
        // array is with categories
        allData = [[NSMutableArray alloc] initWithArray: arr];
        
        if (depth > 1) {
            [self getProductsToShow];
        }
        else{
            [self gotNewData];
            [self.table reloadData];
        }

    }
    else{
        gettingProducts = NO;
        [allData addObjectsFromArray: arr];
        [self gotNewData];
        [self.table reloadData];
    }
}

- (void)addToList:(id)sender{
    
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddCategoryController" owner:nil options:nil];
    UINavigationController * navController = [arr objectAtIndex:0];
    
    MedtronicAboveNavigationController * above = [[navController viewControllers] objectAtIndex:0];
    //above.type = self.type;
    
    AddCategoryViewController * next = [[AddCategoryViewController alloc] initWithNibName:@"AddCategoryViewController" bundle:nil];
    next.type = self.type;
    next.depth = self.depth;
    next.parentCategory = parentCategory;
    
    above.rootView = next;
    
    //[self.tabBarController presentModalViewController:navController animated:YES];
    
    [((UIViewController*)self.myStack.delegate) presentViewController:navController animated:YES completion:nil];
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
