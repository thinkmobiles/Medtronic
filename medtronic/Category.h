//
//  Category.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-26.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicObject.h"

@interface Category : MedtronicObject{
    BOOL isUserDefined;
    int depth;
    int type;
}

@property BOOL isUserDefined;
@property int depth;
@property int type;

@end
