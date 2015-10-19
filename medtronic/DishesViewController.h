//
//  DishesViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractMedtronicExclusiveButtonsController.h"
#import "AddDishViewController.h"

@interface DishesViewController : AbstractMedtronicExclusiveButtonsController<AddDishDelegate>{
    BOOL showMineModal;
}

@property BOOL showMineModal;

- (void) dishWasNotAdded: (NSNotification *) notif;
- (void) dishWasAdded: (NSNotification *) notif;

@end
