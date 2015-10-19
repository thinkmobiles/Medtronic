//
//  AbstractMedtronicStackViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicStackViewController.h"
#import "AbstractMedtronicViewController.h"

@implementation AbstractMedtronicStackViewController

@synthesize
controllersStack,
currentController,
delegate;

- (id) initWitRootController: (AbstractMedtronicViewController *) rootView{
    self = [super init];
    
    controllersStack = [[NSMutableArray alloc] init];
    [self pushViewController: rootView silent:YES withPrevious:nil];
    
    return self;
}


- (void) pushViewController: (AbstractMedtronicViewController *) newOne withPrevious: (AbstractMedtronicViewController *) prev{
    [self pushViewController: newOne silent:NO withPrevious: prev];
}

- (void) popViewController{
    [self popViewControllerSilent: NO];
}

- (void) pushViewController:(AbstractMedtronicViewController *)newOne silent: (BOOL) isSilent withPrevious: (AbstractMedtronicViewController *) prev{
    
    [controllersStack addObject: newOne];
    
    if (!isSilent) {
        newOne.previousController = prev;
    }
    
    self.currentController = newOne;
    
    newOne.myStack = self;
    
    if (!isSilent) {
        [delegate viewChangedInController: self];
    }
}


- (void) popViewControllerSilent: (BOOL) isSilent{
    if ([controllersStack count] == 1) {
        return;
    }
    AbstractMedtronicViewController * lastOne = [controllersStack lastObject];
    lastOne.myStack = nil;
    [controllersStack removeLastObject];
    
    self.currentController = [controllersStack lastObject];
    
    
    if (!isSilent) {
        [delegate viewChangedInController: self];
    }
}

- (void) pushControllerAbove: (AbstractMedtronicViewController *) aboveOne withPrevious: (AbstractMedtronicViewController *) prev{

    
}

- (void) popControllerAbove{
    
}

@end
