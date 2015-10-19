//
//  PopupsManager.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-23.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "PopupsManager.h"
#import "Settings.h"
#import "AppDelegate.h"
#import "PopupWelcomeView.h"
#import "PopupTutorial.h"

@implementation PopupsManager


- (void) showPopups{
    popupsArray = [[NSMutableArray alloc] init];
    
    //if ([Settings sharedSingleton].runCounter == 1) {
        [self initFirstRunPopups];
    //}
    //else if([Settings sharedSingleton].runCounter == 2){
    //    [self initSecondRunPopups];
    //}
    
    if ([popupsArray count] > 0) {
        PopupView * next = [popupsArray objectAtIndex: 0];
        next.indexOfPopup = 0;
        [[((AppDelegate*)[UIApplication sharedApplication].delegate) window] addSubview: next];
    }
}

- (void) initFirstRunPopups{
    PopupWelcomeView * welcome = [[PopupWelcomeView alloc] initWithFrame:CGRectMake(0, (480-[UIImage imageNamed:@"popup_screen.png"].size.height)/2, 320, 480)];
    welcome.delegate = self;
    [popupsArray addObject:welcome];
    
    for (int i = 0; i < 9; ++i) {
        PopupTutorial * tut1 = [[PopupTutorial alloc] initWithFrame:CGRectMake(0, (480-[UIImage imageNamed:@"popup_screen.png"].size.height)/2, 320, 480)];
        tut1.delegate = self;
        [tut1 setAppropriateImage: [NSString stringWithFormat:@"tutorial_%d.png", (i+1)]];
        [popupsArray addObject:tut1];
    }
    
}

- (void) initSecondRunPopups{
    
}

- (void) popupViewFinished:(PopupView *)popup{
    [popup removeFromSuperview];
    
    if (popup.indexOfPopup >= 0) {
        
        if (popup.indexOfPopup < [popupsArray count]-1) {
            
            PopupView * next = [popupsArray objectAtIndex: popup.indexOfPopup+1];
            next.indexOfPopup = popup.indexOfPopup+1;
            [[((AppDelegate*)[UIApplication sharedApplication].delegate) window] addSubview: next];
        }
    }
}


@end
