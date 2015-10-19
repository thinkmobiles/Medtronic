//
//  CheckboxTableRow.h
//  medtronic
//
//  Created by LooksoftHD on 24.04.2014.
//  Copyright (c) 2014 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface CheckboxTableRow : UITableViewCell

@property (nonatomic, assign) Category * category;
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIButton * checkboxButton;

+ (CheckboxTableRow *)cellFromNibNamed:(NSString *)nibName;

@end
