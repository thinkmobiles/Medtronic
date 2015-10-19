//
//  MedtronicAboveNavigationController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "AbstractMedtronicStackViewController.h"

@interface MedtronicAboveNavigationController : AbstractMedtronicViewController
<MedtronicStackViewControllerDelegate>{
   
    AbstractMedtronicStackViewController * stackController;
    AbstractMedtronicViewController * selectedView;
    AbstractMedtronicViewController * rootView;
}

@property (nonatomic, retain) AbstractMedtronicViewController * rootView;

@end
