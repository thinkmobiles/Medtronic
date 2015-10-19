//
//  AbstractMedtronicStackViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#ifndef MED_H
#define MED_H

#import <Foundation/Foundation.h>
//#import "AbstractMedtronicViewController.h"

@class AbstractMedtronicStackViewController;
@class AbstractMedtronicViewController;


@protocol MedtronicStackViewControllerDelegate <NSObject>

- (void) viewChangedInController: (AbstractMedtronicStackViewController*) navController;
- (void) pushControllerAbove: (AbstractMedtronicViewController *) aboveOne withPrevious: (AbstractMedtronicViewController *) prev;
- (void) popControllerAbove;

@end


@interface AbstractMedtronicStackViewController : NSObject{

    NSMutableArray * controllersStack;
    AbstractMedtronicViewController * currentController;
    id<MedtronicStackViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray * controllersStack;
@property (nonatomic, retain) AbstractMedtronicViewController * currentController;
@property (nonatomic, retain) id<MedtronicStackViewControllerDelegate> delegate;


- (id) initWitRootController: (AbstractMedtronicViewController *) rootView;

- (void) pushViewController: (AbstractMedtronicViewController *) newOne withPrevious: (AbstractMedtronicViewController *) prev;
- (void) popViewController;

- (void) pushViewController:(AbstractMedtronicViewController *)newOne silent: (BOOL) isSilent withPrevious: (AbstractMedtronicViewController *) prev;
- (void) popViewControllerSilent: (BOOL) isSilent;

@end

#endif
