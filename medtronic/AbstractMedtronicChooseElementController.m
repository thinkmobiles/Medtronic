//
//  AbstractMedtronicChooseElementController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-03.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicChooseElementController.h"
#import "ElementsListViewController.h"

@implementation AbstractMedtronicChooseElementController

@synthesize addDelegate;

- (void) setAddDelegates{
    for (AbstractMedtronicStackViewController * v in controllersArray) {
        ((ElementsListViewController*)v.currentController).addDelegate = addDelegate;
    }
}

@end
