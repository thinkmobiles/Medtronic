//
//  Ingredient.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Element.h"

@interface Ingredient : NSObject{

    Element * element;
    double weight;
    double scalingFactor;
}

@property (nonatomic, retain) Element * element;
@property double weight;
@property double scalingFactor;

- (id) initWithWeight: (double) _weight andElement: (Element *) _element;
- (void) setAllParametres;
- (Ingredient *) clone;

@end
