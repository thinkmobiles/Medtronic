//
//  PopupView.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-08-23.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupView;

@protocol PopupViewDelegate <NSObject>

- (void) popupViewFinished: (PopupView *) popup;

@end

@interface PopupView : UIView{
    id<PopupViewDelegate> delegate;
    int indexOfPopup;
}

@property (nonatomic, retain) id<PopupViewDelegate> delegate;
@property int indexOfPopup;

@end
