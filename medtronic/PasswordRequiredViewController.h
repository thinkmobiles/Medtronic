//
//  PasswordRequiredViewController.h
//  medtronic
//
//  Created by Apple Saturn on 12-09-06.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractBackupViewController.h"

@interface PasswordRequiredViewController : AbstractBackupViewController{
    NSString * email;
    NSString * db;
}

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * db;

@end
