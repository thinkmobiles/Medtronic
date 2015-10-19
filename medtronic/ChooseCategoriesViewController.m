//
//  ChooseCategoriesViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ChooseCategoriesViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "MedtronicConstants.h"
#import "CheckboxTableRow.h"

@implementation ChooseCategoriesViewController
@synthesize categoryLabel;

@synthesize
delegate,
howMany,
preChosenCategories;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(int)thetype{
    self = [super initWithNibName:nibNameOrNil andType:thetype];
    if (self) {
        delegate = nil;
        preChosenCategories = [[NSArray alloc] init];
        _chosenCategoriesDict = [[NSMutableDictionary alloc] init];
        _chosenCategoriesArray = [[NSMutableArray alloc] init];
        
        howMany = 1;
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
//    radioButtons.maxSelected = howMany;
    if (parentCategory) {
        [categoryLabel setText: parentCategory.name];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.searchBar.layer.borderWidth = 1;
        self.searchBar.layer.borderColor = [[UIColor lightTintColor] CGColor];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    NSString * title = @"";
    switch (type) {
        case PRODUCT:
            title = @"Kategorie produktów";
            break;
            
        case DISH:
            title = @"Kategorie potraw";
            break;
            
        default:
            title = @"Kategorie posiłków";
            break;
    }
    
    [[self myRealNavigationItem] setTitle: title];
    
    //if (depth == 1) {
    [self addOkButton];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell == noneTableViewCell || cell == addTableViewCell) {
        return cell;
    }
    
    int index = [indexPath row];
    if (addRow) {
        index -= 1;
    }
    
    Category * obj;
    if (searchFilter) {
        obj = [searchResults objectAtIndex: index];
    }
    else{
        obj = [allData objectAtIndex: index];
    }
    
    if (!cell || ![cell isKindOfClass: [CheckboxTableRow class]]) {
        cell = [CheckboxTableRow cellFromNibNamed: @"CheckboxTableRow"];
        [((CheckboxTableRow *)cell).checkboxButton addTarget:self action:@selector(buttonSelected:) forControlEvents: UIControlEventTouchUpInside];
    }
    [cell setBackgroundView: [[UIImageView alloc] initWithImage: (index % 2) == 0 ? [UIImage imageNamed:@"table_bkg_w.png"] : [UIImage imageNamed:@"table_bkg.png"] ]];
    [cell setSelectedBackgroundView: [[UIImageView alloc] initWithImage:  (index % 2) == 0 ? [UIImage imageNamed:@"table_bkg_s_w.png"] : [UIImage imageNamed:@"table_bkg_s.png"] ]];
    
    CheckboxTableRow * checkboxCell = (CheckboxTableRow *)cell;
    checkboxCell.category = obj;
    checkboxCell.checkboxButton.selected = ([_chosenCategoriesDict objectForKey: [NSNumber numberWithInt: obj.theid]] != nil);
    checkboxCell.label.text = obj.name;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)gotNewData{
    removeRowIndex = -1;
}

- (void)objectSelected:(MedtronicObject *)obj{
    if (depth == 3 || type != PRODUCT) {
        
    }
    else{
        [self goIntoCategory: obj];
    }
}

- (BOOL) goIntoCategory: (MedtronicObject*) med{
    ChooseCategoriesViewController * deeper = [[ChooseCategoriesViewController alloc] initWithNibName:@"ChooseCategoriesViewController" andType: type];
    deeper.parentCategory = (Category*)med;
    deeper.preChosenCategories = [NSArray arrayWithArray: preChosenCategories];
    preChosenCategories = [NSArray array];
    [deeper setDepth: depth+1];
    deeper.delegate = self.delegate;
    [self.myStack pushViewController: deeper withPrevious: self];
    return YES;
}

- (void)okAdd:(id)sender{
    
    if ([_chosenCategoriesArray count] == 0) {
        [self showMessage: howMany == 1 ? @"Wybierz kategorię lub naciśnij 'Wstecz', aby anulować" : [NSString stringWithFormat:@"Wybierz od 1 do %d kategorii lub naciśnij 'Wstecz', aby anulować", howMany]];
        return;
    }
    [delegate chosenCategories: [NSArray arrayWithArray: _chosenCategoriesArray]];
}


- (void)viewDidUnload {
    [self setCategoryLabel:nil];
    [super viewDidUnload];
}

- (void)buttonSelected:(UIButton *)button{
    
    UIView * superView = button.superview;
    while (![superView isKindOfClass: [CheckboxTableRow class]]) {
        superView = superView.superview;
        if (superView == nil) {
            break;
        }
    }
    Category * selectedOne = ((CheckboxTableRow *)superView).category;
    NSNumber * key = [NSNumber numberWithInt: selectedOne.theid];
    
    if ([_chosenCategoriesDict objectForKey: key]) {
        [_chosenCategoriesDict removeObjectForKey: key];
        for (Category * cat in _chosenCategoriesArray) {
            if (cat.theid == selectedOne.theid) {
                [_chosenCategoriesArray removeObject: cat];
                break;
            }
        }
    }
    else{
        [_chosenCategoriesArray addObject: selectedOne];
        [_chosenCategoriesDict setObject: selectedOne forKey: key];
    }
    
    while ([_chosenCategoriesArray count] > howMany) {
        Category * lastOne = [_chosenCategoriesArray firstObject];
        [_chosenCategoriesDict removeObjectForKey: [NSNumber numberWithInt: lastOne.theid]];
        [_chosenCategoriesArray removeObject: lastOne];
    }
    [self.table reloadData];
}

@end
