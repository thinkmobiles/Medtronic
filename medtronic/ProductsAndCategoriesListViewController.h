//
//  ProductsAndCategoriesListViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicListViewController.h"
#import "ElementsListViewController.h"
#import "Category.h"

@interface ProductsAndCategoriesListViewController : ElementsListViewController{
    //Category * parentCategory;
    int depth;
    
    //int mainFilter;
    BOOL gettingProducts;
}

//@property (nonatomic, retain) Category * parentCategory;
@property int depth;
//@property int mainFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(int)thetype andMainFilter: (int) filter;
- (void) getProductsToShow;
- (NSString *) getAppropriateProductsSelect;

@end
