//
//  CategorySerializable.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-09-04.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Category.h"

@interface CategorySerializable : Category{
    NSMutableArray * subCategories;
    int parentId;
    BOOL isInto;
}

@property BOOL isInto;

- (NSDictionary *) prepareSerializedObject;
- (NSString *) deserializeFromJson: (NSDictionary *) dict;

@end
