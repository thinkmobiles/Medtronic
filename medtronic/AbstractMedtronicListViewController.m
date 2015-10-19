//
//  AbstractMedtronicListViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicListViewController.h"
#import "MedtronicObject.h"
#import "AbstractMedtronicStackViewController.h"
#import "Element.h"
#import "MedtronicConstants.h"

@implementation AbstractMedtronicListViewController

@synthesize
type, allData;
@synthesize table;
@synthesize searchBar, searchResults, searchString;

- (id)initWithNibName:(NSString *)nibNameOrNil andType: (int) thetype{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        type = thetype;
        addRow = NO;
        removeRowIndex = -1;
        searchShouldBegin = YES;
    }
    return self;
}

- (void)viewDidUnload {
    [self setTable:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    allData = [[NSMutableArray alloc] init];
    searchResults = [[NSArray alloc] init];
    searchString = [[NSString alloc] init];
    
    searchFilter = NO;
    prevAddRow = NO;
    justCleared = NO;
    
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"NoneTableRow" owner:nil options:nil];
    noneTableViewCell = [arr objectAtIndex: 0];
    [noneTableViewCell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    //UIView * subview;
    for(UIView * subView in self.searchBar.subviews)
    {
        if( [subView isKindOfClass:[UITextField class]] )
        {
            ((UITextField*)subView).delegate=self;
            //((UITextField*)subView).returnKeyType=UIReturnKeyDone;
            break;
        }
    }
    tap.delegate = self;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.searchBar.layer.borderWidth = 1;
        self.searchBar.layer.borderColor = [[UIColor lightTintColor] CGColor];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self getDataToShow];
    
    if (self.view.superview) {
        [self.view setFrame:CGRectMake(0, 0, self.view.superview.frame.size.width, self.view.superview.frame.size.height)];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int index = [indexPath row];
    MedtronicObject * obj = nil;
    
    if (searchFilter && [searchResults count] == 0) {
        return noneTableViewCell;
    }
    if ([allData count] == 0 && (!addRow || (addRow && index > 0) ) && (removeRowIndex != index)) {
        return noneTableViewCell;
    }
    
    if (searchFilter) {
        obj = [searchResults objectAtIndex: index];
    }else{
        if (addRow && index == 0) {
            
            if (addTableViewCell) {
                return addTableViewCell;
            }
            NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"AddCategoryTableRow" owner:nil options:nil];
            addTableViewCell = [arr objectAtIndex: 0];
            [addTableViewCell setBackgroundView: [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"add_button.png"]] ];
            [addTableViewCell setSelectedBackgroundView: [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"add_button_s.png"]]];
            
            return addTableViewCell;
        }
        
        if (removeRowIndex == index) {
            
            if (removeTableViewCell) {
                return removeTableViewCell;
            }
            NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"RemoveCategoryTableRow" owner:nil options:nil];
            removeTableViewCell = [arr objectAtIndex: 0];
            [removeTableViewCell setBackgroundView: [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"delete_button.png"]] ];
            [removeTableViewCell setSelectedBackgroundView: [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"delete_button_s.png"]]];
            
            return removeTableViewCell;
        }
        
        if (addRow) {
            index -= 1;
        }
        if (removeRowIndex > -1) {
            index -= 1;
        }
        
        obj = [allData objectAtIndex: index];
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableRow"];
    
    if (!cell) {
        NSArray * objects = [[NSBundle mainBundle] loadNibNamed:@"TableRow" owner:nil options:nil];
        cell = [objects objectAtIndex:0];
        
    }
    [cell setBackgroundView: [[UIImageView alloc] initWithImage: (index % 2 == 0) ? [UIImage imageNamed:@"table_bkg_w.png"] : [UIImage imageNamed:@"table_bkg.png"]] ];
    [cell setSelectedBackgroundView: [[UIImageView alloc] initWithImage: (index % 2 == 0) ? [UIImage imageNamed:@"table_bkg_s_w.png"] : [UIImage imageNamed:@"table_bkg_s.png"]]];
    
    
    [[cell viewWithTag: LINE_TAG] setHidden: !(index == 0 && !addRow && removeRowIndex==-1)];
    
    UILabel * label = (UILabel *)[cell viewWithTag: LABEL_TAG];
    [label setText: obj.name];
    
    UIImageView * userAddedIcon = (UIImageView *)[cell viewWithTag: USER_ADDED_ICON_TAG];
    if ([obj isKindOfClass: [Element class]]) {
        userAddedIcon.hidden = ![(Element *)obj isUserDefined];
    }
    else{
        userAddedIcon.hidden = YES;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (searchFilter) {
        MedtronicObject * obj = [searchResults objectAtIndex: [indexPath row]];
        [self objectSelected: obj];
    }
    else{
        if (addRow && [indexPath row] == 0) {
            [self addToList: self];
            [table deselectRowAtIndexPath: [NSIndexPath indexPathWithIndex: [indexPath row]] animated:YES];
            return;
        }
        if (removeRowIndex == [indexPath row]) {
            [self removeFromList: self];
            [table deselectRowAtIndexPath: [NSIndexPath indexPathWithIndex: [indexPath row]] animated:YES];
            return;
        }
        if ([allData count] == 0) {
            return;
        }
        
        int index = [indexPath row];
        if (addRow) {
            index -=1;
        }
        if (removeRowIndex > -1) {
            index -=1;
        }
       
        MedtronicObject * obj = [allData objectAtIndex: index];
        [self objectSelected: obj];
    }
}

- (void) objectSelected: (MedtronicObject *) obj{
}

- (void)removeFromList:(id)sender{}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (searchFilter) {
        return [searchResults count] == 0 ? 1 : [searchResults count];
    }
    
    int all = [allData count];
    if (all == 0) {
        all+=1;
    }
    
    if (addRow) {
        all += 1;
    }
    
    if (removeRowIndex > -1) {
        all +=1;
    }
    
    return all;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (searchFilter && [searchResults count] == 0) {
        return nil;
    }
    if (!searchFilter && ([allData count] == 0 && !addRow && removeRowIndex == -1)) {
        return nil;
    }
    return indexPath;
}


- (NSString *) getAppropriateSelect{
    return @"";
}

- (MedtronicObject *) getAppropriateEmptyObject{
    return [[MedtronicObject alloc] init];
}

- (void) getDataToShow{
    NSString * query = [self getAppropriateSelect];
    MedtronicObject * obj = [self getAppropriateEmptyObject];
    
    [[SQLiteController sharedSingleton] execSelect: query getObjectsLike:obj for: self];
}


- (void)didReceiveArray:(NSMutableArray *)arr{
    
    allData = [[NSMutableArray alloc] initWithArray: [arr sortedArrayUsingFunction:finderSortWithLocale                                                                                                          context: (__bridge void *)[NSLocale currentLocale]]];
    [self gotNewData];
    [self.table reloadData];
}

- (void) addToList:(id)sender{
}

- (void) gotNewData{}

- (void) filterContentForSearchText: (NSString *) searchText {
    
    NSString * str = [NSString stringWithFormat:@"name beginswith[cd] '%@'", searchText];
    NSPredicate * resultPredicate = [NSPredicate predicateWithFormat: str ];
    
    self.searchResults = [NSArray arrayWithArray: [self.allData filteredArrayUsingPredicate:resultPredicate]];
    searchResults = [[NSMutableArray alloc] initWithArray: [searchResults sortedArrayUsingFunction:finderSortWithLocale                                                                                                          context: (__bridge void *)[NSLocale currentLocale]]];
    
    //NSLog(@"Wyszukało: %d", [self.searchResults count]);
    [table reloadData];
}

int finderSortWithLocale(MedtronicObject *person1, MedtronicObject *person2, void *locale)
{
    
    return [person1.name localizedCaseInsensitiveCompare: person2.name];
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)sb{
    if ([searchString length] == 0) {
        
    }
    [self myTextViewDidBeginEditing: sb];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self dismissKeyboard];
}
/*
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    BOOL boolToReturn = searchShouldBegin;
    searchShouldBegin = YES;
    return boolToReturn;
}
 */

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    searchFilter = NO;
    addRow = prevAddRow;
    searchShouldBegin = NO;
    justCleared = YES;
    searchResults = [[NSArray alloc] init]; 
    [self dismissKeyboard];
    [table reloadData];
    //[textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (justCleared) {
        justCleared = NO;
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITextField class]]|| [touch.view.superview isKindOfClass:[UITextField class]]) {
        return NO;
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (justCleared) {
        return;
    }
    
    if ([searchText length] > 0 && !searchFilter) {
        searchFilter = YES;
        prevAddRow = addRow;
        addRow = NO;
        //[table reloadData];
    }
    
    NSLog(@"%@ %@", searchText, searchString);
    
    if ([searchString length] > 0 && [searchText length] == 0) {
        searchFilter = NO;
        addRow = prevAddRow;
        searchShouldBegin = NO;
        searchResults = [[NSArray alloc] init]; 
        [table reloadData];
        return;
    }
    
    [self filterContentForSearchText: searchText];
    searchString = [NSString stringWithString: searchText];
}


/*
- (void)animateTextField:(UIView *)textField up:(BOOL)up{
    if (textField.superview == [UISearchBar class]) {
        return;
    }
    [super animateTextField:textField up:up];
}*/

@end
