//
//  MealsViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractMedtronicExclusiveButtonsController.h"
#import "PopupsManager.h"

@interface MealsViewController : AbstractMedtronicExclusiveButtonsController{
    PopupsManager * popsManager;
}
@property (nonatomic, retain) PopupsManager * popsManager;

- (void) mealWasAdded: (NSNotification *) notif;
- (void) mealWasNotAdded: (NSNotification *) notif;

@end
