//
//  AddCategoryViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-09.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "SQLiteController.h"
#import "Utils.h"
#import "MedtronicConstants.h"

@implementation AddCategoryViewController
@synthesize categoryView;
@synthesize mainLabel;
@synthesize categoryLabel;
@synthesize nameTextField;
@synthesize nameView;
@synthesize mainView;

@synthesize type, parentCategory, depth;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    BOOL hasAbove = (parentCategory != nil);
    
    
    if (type == PRODUCT) {
        [mainLabel setText: hasAbove ? @"Nowa podkategoria kategorii produktów:" : @"Nowa kategoria produktów:"];
    }
    else{
        [mainLabel setText:@"Nowa kategoria potraw:"];
    }
    
    if (!hasAbove) {
        
        [nameView setFrame: CGRectMake(categoryView.frame.origin.x, categoryView.frame.origin.y+1, nameView.frame.size.width, nameView.frame.size.height)];
        
//        [nameView setFrame: categoryView.frame];
        //[nameView removeFromSuperview];
        [categoryView removeFromSuperview];
        [mainView setBackgroundColor: [UIColor whiteColor]];
        [self.view addSubview: nameView];
    }
    else{
        [categoryLabel setText: parentCategory.name];
    }
    
    [self addOkButton];
    [self addCancelButton];
    
    [[self myRealNavigationItem] setTitle:@"Dodaj kategorię"];
}

- (void)viewDidUnload {
    [self setNameView:nil];
    [self setCategoryView:nil];
    [self setMainView:nil];
    [super viewDidUnload];
}

- (void)cancel:(id)sender{
    [[self myRealNavigationController] dismissViewControllerAnimated:YES completion: nil];
}

- (void)okAdd:(id)sender{
    
    NSString * err = [self validate];
    if (err) {
        [self showError: err];
        return;
    }
    
    int next = [[SQLiteController sharedSingleton] getNextCategoryId];
    NSMutableString * str = [NSMutableString stringWithFormat:@"INSERT INTO category VALUES ('%d','%@','%d','%d','1');", next, [Utils uppercaseSentence: nameTextField.text], self.type, self.depth];
    if (parentCategory) {
        [str appendFormat:@"INSERT INTO category_has_category VALUES ('%d','%d');", next, parentCategory.theid];
    }
    
    
    [[SQLiteController sharedSingleton] commitTransaction: str];
    
    [self showMessage:@"Dodano kategorię"];
    [[self myRealNavigationController] dismissViewControllerAnimated:YES completion: nil];
}

- (NSString *) validate{
    if ([nameTextField.text length] == 0) {
        return @"Wpisz nazwę kategorii";
    }
    return nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [Utils textField:textField shouldChangeCharactersInRange:range replacementString:string withMaximumLimit: MAX_CATEGORY_NAME_LIMIT];
}

@end
