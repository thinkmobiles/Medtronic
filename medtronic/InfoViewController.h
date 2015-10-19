//
//  InfoViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractMedtronicViewController.h"

@interface InfoViewController : AbstractMedtronicViewController
<UITableViewDelegate, UITableViewDataSource>{

    // array of ButtonView
    NSMutableArray * array;
    NSString * titleFromJson;
}

- (void) addSettingsButton;
- (IBAction) settingsClicked:(id)sender;

@property (nonatomic, retain) NSMutableArray * array;
@property (nonatomic, retain) NSString * titleFromJson;

@end
