//
//  ProductsViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractMedtronicChooseElementController.h"
#import "Settings.h"
#import "AddProductViewController.h"


@interface ProductsViewController : AbstractMedtronicChooseElementController <AddProductDelegate>


@end
