//
//  PopupsManager.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-23.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopupView.h"

@interface PopupsManager : NSObject <PopupViewDelegate>{

    NSMutableArray * popupsArray;
}


- (void) showPopups;
- (void) initFirstRunPopups;
- (void) initSecondRunPopups;

@end
