//
//  AbstractMedtronicListViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "SQLiteController.h"


@interface AbstractMedtronicListViewController : AbstractMedtronicViewController
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SQLiteControllerDelegate, UIGestureRecognizerDelegate>{

    int type;
    NSMutableArray * allData;
    
    NSArray * searchResults;
    NSString * searchString;
    BOOL searchFilter;
    BOOL searchShouldBegin;
    
    BOOL addRow;
    int removeRowIndex;
    BOOL prevAddRow;
    BOOL justCleared;
    UITableViewCell * addTableViewCell;
    UITableViewCell * removeTableViewCell;
    UITableViewCell * noneTableViewCell;
}

@property int type;
@property (nonatomic, retain) NSMutableArray * allData;
@property (nonatomic, retain) NSArray * searchResults;
@property (nonatomic, retain) NSString * searchString;

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *table;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil andType: (int) thetype;

- (NSString *) getAppropriateSelect;
- (void) getDataToShow;
- (void) objectSelected: (MedtronicObject *) obj;

- (void) addToList:(id)sender;
- (void) removeFromList: (id) sender;

- (void) filterContentForSearchText: (NSString *) searchText;

- (void) gotNewData;
- (int) sortObjectsWithLocaleFor: (MedtronicObject *) object1 with: (MedtronicObject *) object2;

int finderSortWithLocale(MedtronicObject *person1, MedtronicObject *person2, void *locale);


@end
