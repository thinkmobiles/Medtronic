//
//  Ingredient.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

@synthesize
element,
weight,
scalingFactor;

- (id) initWithWeight: (double) _weight andElement: (Element *) _element{
    self = [super init];
    
    weight = _weight;
    element = _element;
    scalingFactor = 1.0f;
    
    [self setAllParametres];
    
    return self;
}

- (void) setAllParametres{
    
}

- (Ingredient *) clone{
    Ingredient * newOne = [[Ingredient alloc] initWithWeight:weight andElement: (Element*)[element clone]];
    newOne.scalingFactor = scalingFactor;
    return newOne;
}

@end
