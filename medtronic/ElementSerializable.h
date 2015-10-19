//
//  ElementSerializable.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-04.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Element.h"

@interface ElementSerializable : Element{
    double weightCooked;
    double weightMeal;
    
    NSMutableArray * ingredients;
    NSMutableArray * categories;
}

@property double weightCooked;
@property double weightMeal;

- (NSDictionary *) prepareSerializedObject;
- (NSString *) deserializeFromJson: (NSDictionary *) dict;

@end
