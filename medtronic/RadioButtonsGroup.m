//
//  RadioButtonsGroup.m
//  home
//
//  Created by Hanna Dutkiewicz on 12-03-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "RadioButtonsGroup.h"

@implementation RadioButtonsGroup

@synthesize
delegate,
maxSelected,
selectedButtons,
alwaysSelected;



- (id) init{

    self = [super init];
    //selectedIndex = -1;
    //selectedButton = nil;
    delegate = nil;
    buttons = [[NSMutableArray alloc] init];
    selectedButtons = [[NSMutableArray alloc] init];
    alwaysSelected = YES;
    maxSelected = 1;
    return self;
}


- (void) addButton: (UIButton *) newOne{
    [newOne  addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];

    [newOne setTag: [buttons count]];
    [buttons addObject: newOne];
    /*
    if (newOne.tag == 0) {
        [newOne setSelected:YES];
        [selectedButtons addObject: ]
        selectedButton = newOne;
        selectedIndex = 0;
    }*/
}

- (void) clear{
    [buttons removeAllObjects];
}

- (IBAction) buttonSelected:(id)sender{
//    int newIndex = ((UIButton *)sender).tag;
    UIButton * newButton = (UIButton *) sender;
    
    if ([selectedButtons containsObject: (UIButton*)sender]) {
        
        if ([selectedButtons count] == 1 && alwaysSelected) {
            return;
        }
        [newButton setSelected:NO];
        [selectedButtons removeObject: newButton];
        return;
    }
    
    [selectedButtons addObject: newButton];
    [newButton setSelected:YES];
    
    if ([selectedButtons count] > maxSelected) {
        UIButton * toRemove = [selectedButtons objectAtIndex:0];
        [toRemove setSelected:NO];
        [selectedButtons removeObject: toRemove];
    }
        
    [delegate buttonSelected: newButton];
}

- (void) setInitialButtonSelected: (int) index{
    if ([buttons count] < index) {
        return;
    }
    UIButton * newOne = [buttons objectAtIndex: index];
    [self buttonSelected: newOne];
}

@end
