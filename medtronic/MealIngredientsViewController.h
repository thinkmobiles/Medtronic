//
//  MealIngredientsViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicChooseElementController.h"
//#import "AddProductViewController.h"
#import "AddDishViewController.h"
#import "AddProductDelegate.h"
#import "AddDishDelegate.h"


//@protocol AddProductDelegate;
//@protocol AddDishDelegate;

@interface MealIngredientsViewController : AbstractMedtronicChooseElementController <AddProductDelegate, AddDishDelegate>{
    
}

- (void) dishWasNotAdded: (NSNotification *) notif;

@end
