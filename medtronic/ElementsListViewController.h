//
//  ElementsListViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicListViewController.h"
#import "AddIngredientWithWeightViewController.h"
#import "Category.h"

@interface ElementsListViewController : AbstractMedtronicListViewController{
    int mainFilter;
    Category * parentCategory;
    
    id<AddIngredientWithWeightDelegate> addDelegate;
}

@property (nonatomic, retain) id<AddIngredientWithWeightDelegate> addDelegate;
@property int mainFilter;
@property (nonatomic, retain) Category * parentCategory;

- (id)initWithNibName:(NSString *)nibNameOrNil andType:(int)thetype andMainFilter: (int) filter;

@end
