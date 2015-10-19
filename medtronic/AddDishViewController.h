//
//  AddDishViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//
#import "AbstractAddElementViewController.h"
#import "AddDishDelegate.h"

//@class Dish;
//@class AbstractAddElementViewController;

@interface AddDishViewController : AbstractAddElementViewController {
    BOOL wasShownAlert;
    
    id<AddDishDelegate> addDishDelegate;
    BOOL alreadyPrepared;
    double weightAfter;
}

@property (nonatomic, retain) id<AddDishDelegate> addDishDelegate;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *terminCheckbox;
@property (unsafe_unretained, nonatomic) IBOutlet UIView * termicView;
@property BOOL alreadyPrepared;
@property BOOL wasShownAlert;
@property double weightAfter;

- (IBAction)buttonSelected:(id)sender;
- (NSString *) validate;

@end
