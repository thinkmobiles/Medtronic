//
//  AddMealViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractAddElementViewController.h"


@interface AddMealViewController : AbstractAddElementViewController{
    AbstractMedtronicViewController * myParent;
    
}

@property (nonatomic, retain) AbstractMedtronicViewController * myParent;

- (NSString *) validate;

 
@end
