//
//  AddDishDelegate.h
//  medtronic
//
//  Created by LooksoftHD on 17.03.2014.
//  Copyright (c) 2014 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"

@protocol AddDishDelegate <NSObject>

- (void) dishWasAdded: (Dish *) element;

@end
