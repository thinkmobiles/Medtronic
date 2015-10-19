//
//  AddCategoryViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-09.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "Category.h"

@interface AddCategoryViewController : AbstractMedtronicViewController <UITextFieldDelegate>{

    int type;
    Category * parentCategory;
    int depth;
}

@property (nonatomic, retain) Category * parentCategory;
@property int type;
@property int depth;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *categoryView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *mainLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *categoryLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameTextField;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *nameView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *mainView;

- (NSString *) validate;

@end
