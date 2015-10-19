//
//  AbstractMedtronicChooseElementController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-03.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicExclusiveButtonsController.h"
#import "AddIngredientWithWeightViewController.h"

@interface AbstractMedtronicChooseElementController : AbstractMedtronicExclusiveButtonsController{
    id<AddIngredientWithWeightDelegate> addDelegate;
}

@property (nonatomic, retain) id<AddIngredientWithWeightDelegate> addDelegate;

- (void) setAddDelegates;

@end
