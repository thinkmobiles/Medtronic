//
//  RadioButtonsGroup.h
//  home
//
//  Created by Hanna Dutkiewicz on 12-03-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RadioButtonsGroupDelegate <NSObject>

- (void) buttonSelected: (UIButton *) button;

@end

/**
 Exclusive radio buttons group.
*/
@interface RadioButtonsGroup : NSObject{
    
    NSMutableArray * buttons;
    int maxSelected;
    NSMutableArray * selectedButtons;
    /*
    UIButton * selectedButton;
    int selectedIndex;
     */
    id<RadioButtonsGroupDelegate> delegate;
    BOOL alwaysSelected;
}

//@property (nonatomic, retain) UIButton * selectedButton;
@property int maxSelected;
@property (nonatomic, retain) NSMutableArray * selectedButtons;
@property BOOL alwaysSelected;
/*
@property int selectedIndex;
*/
@property (nonatomic, retain) id<RadioButtonsGroupDelegate> delegate;

 
- (void) addButton: (UIButton *) newOne;
- (void) clear;
- (void) setInitialButtonSelected: (int) index;

- (IBAction) buttonSelected:(id)sender;

@end
