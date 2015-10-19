//
//  CategoriesViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicListViewController.h"
#import "Category.h"


@interface CategoriesViewController : AbstractMedtronicListViewController{

    Category * parentCategory;
    int depth;
}
// type = { MEAL, DISH, PRODUCT }
@property (nonatomic, retain) Category * parentCategory;
@property int depth;


- (void) goIntoElements: (MedtronicObject *) parentid;
- (BOOL) goIntoCategory: (MedtronicObject *) parentid;

@end
