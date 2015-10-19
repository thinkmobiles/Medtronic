//
//  Element.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicObject.h"

@interface Element : MedtronicObject{
    double fat;
    double fiber;
    double carbs;
    double kcal;
    double protein;
    double ww;
    double wbt;
    double wm;
    double wbt_proc;
    int type;
    BOOL isFavourite;
    BOOL isUserDefined;
    NSString * imgName;
}

@property double fat;
@property double fiber;
@property double carbs;
@property double kcal;
@property double protein;
@property double ww;
@property double wbt;
@property double wm;
@property double wbt_proc;
@property int type;
@property BOOL isFavourite;
@property BOOL isUserDefined;
@property (nonatomic, retain) NSString * imgName;



@end
