//
//  AbstractMedtronicExclusiveButtonsController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicStackViewController.h"
#import "AbstractMedtronicViewController.h"

@protocol PlusElementDelegate <NSObject>

- (void) elementAdded: (int) theid ofType: (int) theType;

@end


@interface AbstractMedtronicExclusiveButtonsController : AbstractMedtronicViewController
<MedtronicStackViewControllerDelegate>{

    NSMutableArray * buttonsArray;
    NSMutableArray * controllersArray;
    
    int selectedIndex;
    AbstractMedtronicStackViewController * selectedController;
    AbstractMedtronicViewController * selectedView;
    
    UIButton * plusButton;
}

@property (nonatomic, retain) AbstractMedtronicStackViewController * selectedController;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *subView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *parentCategoryLabel;


- (IBAction)exclusiveButtonClicked:(id)sender;
- (void) initControllers;
- (void) addPlusButton;
- (IBAction) plusButtonClicked:(id)sender;

@end
