//
//  TPKeyboardAvoidingScrollView.h
//  citiboard
//
//  Created by LooksoftHD on 14.12.2012.
//  Copyright (c) 2012 LooksoftHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPKeyboardAvoidingScrollView : UIScrollView {
    UIEdgeInsets _priorInset;
    BOOL _priorInsetSaved;
    CGRect _keyboardRect;
    CGSize _originalContentSize;
}

@property (readonly) BOOL keyboardVisible;

- (void)adjustOffsetToIdealIfNeeded;

@end
