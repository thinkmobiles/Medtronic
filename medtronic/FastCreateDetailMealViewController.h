//
//  FastCreateDetailMealViewController.h
//  medtronic
//
//  Created by Apple Saturn on 12-10-12.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailMealViewController.h"

@interface FastCreateDetailMealViewController : DetailMealViewController<IngredientsViewDelegate>{
    
}

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *saveMealButton;

@end
