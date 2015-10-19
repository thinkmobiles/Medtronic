//
//  CategoriesViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "CategoriesViewController.h"
#import "Category.h"
#import "AbstractMedtronicStackViewController.h"
#import "ElementsListViewController.h"
#import "AbstractMedtronicListViewController.h"
#import "AddCategoryViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "MedtronicConstants.h"

@implementation CategoriesViewController

@synthesize
depth,
parentCategory;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(int)thetype{
    self = [super initWithNibName:nibNameOrNil andType:thetype];
    depth = 1;
    parentCategory = nil;
    
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    if ((depth <= 3 && type == PRODUCT) || (depth == 1 && type == DISH)) {
        addRow = YES;
        
    }
}


- (NSString *) getAppropriateSelect{
    
    if (parentCategory) {
        
        NSString * sel = [NSString stringWithFormat: @"SELECT * FROM CATEGORY JOIN CATEGORY_HAS_CATEGORY ON CATEGORY.id = CATEGORY_HAS_CATEGORY.id_child WHERE CATEGORY.type=%d AND CATEGORY_HAS_CATEGORY.id_parent=%d ORDER BY name COLLATE NOCASE", type, parentCategory.theid];
        return sel;
    }
    
    if (type != PRODUCT) {
        return [NSString stringWithFormat: @"SELECT * FROM CATEGORY WHERE type=%d ORDER BY %@ COLLATE NOCASE", type, type == MEAL ? @"id" : @"name"];
    }
    return [NSString stringWithFormat: @"SELECT * FROM CATEGORY WHERE type=%d AND depth=%d ORDER BY %@ COLLATE NOCASE", type, depth, @"name"];
}

- (MedtronicObject *) getAppropriateEmptyObject{
    return [[Category alloc] init];
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


- (void)objectSelected:(MedtronicObject *)obj{
    if ((depth < 3 && type == PRODUCT)) {
        [self goIntoCategory: obj];
    }
    else{
        [self goIntoElements: obj];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == addTableViewCell) {
        return cell;
    }
    if (cell == noneTableViewCell) {
        return cell;
    }
    
    UILabel * label = (UILabel *)[cell viewWithTag: LABEL_TAG];
    [label setTextColor: [UIColor blackColor]];
    //[label setFont: [UIFont boldSystemFontOfSize:14]];
    //[label setMinimumFontSize: 12];
    return cell;
}


- (void) goIntoElements:(MedtronicObject *) parent{
    ElementsListViewController * els = [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: type andMainFilter: ALL];
    [els setParentCategory: (Category*)parent];
    //[els setCategoryName: parent.name];
    [self.myStack pushViewController: els withPrevious:self];
}


- (BOOL) goIntoCategory: (MedtronicObject *) parent{
    CategoriesViewController * deeper = [[CategoriesViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: type];
    deeper.parentCategory = (Category*)parent;
    [deeper setDepth: depth+1];
    
    //BOOL push = [[SQLiteController sharedSingleton] hasElementsLike: [deeper getAppropriateSelect]];
    
    //if (push) {
        [self.myStack pushViewController: deeper withPrevious: self];
    //}
    return YES;
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

@end
