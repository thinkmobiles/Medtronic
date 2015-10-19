//
//  CheckboxTableRow.m
//  medtronic
//
//  Created by LooksoftHD on 24.04.2014.
//  Copyright (c) 2014 Looksoft Sp. z o. o. All rights reserved.
//

#import "CheckboxTableRow.h"
#import "MedtronicConstants.h"

@implementation CheckboxTableRow

+ (CheckboxTableRow *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CheckboxTableRow *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CheckboxTableRow class]]) {
            customCell = (CheckboxTableRow *)nibItem;
            
            customCell.checkboxButton = (UIButton *)[customCell viewWithTag: CHECKBOX_TAG];
            customCell.label = (UILabel *)[customCell viewWithTag: LABEL_TAG];
            
            break; // we have a winner
        }
    }
    return customCell;
}


@end
