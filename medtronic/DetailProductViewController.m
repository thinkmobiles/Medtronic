//
//  DetailProductViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "DetailProductViewController.h"
#import "SQLiteController.h"
#import "FoodParametres.h"

@implementation DetailProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andObject: (MedtronicObject*) obj{
    self = [super initWithNibName:nibNameOrNil bundle: nil];
    if (self) {
        object = (Element *)obj;
        currentWeight = 100.0f;
    }
    return self;
}

- (void)viewDidLoad{
  
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setTitle:@"Produkty"];
    
    self.subValuesView.frame = CGRectMake(0, self.subValuesView.frame.origin.y, self.subValuesView.frame.size.width, [Utils isiPhone5] ? 311 : (311-88));
    
    valuesView = [[NutricionFactsView alloc] initWithFrame: CGRectMake(0, 0, self.subValuesView.frame.size.width, self.subValuesView.frame.size.height) ];
    
    NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", object.theid];
    object = (Element*)[[SQLiteController sharedSingleton] execSelect:sel fillObject:object];
    //ingredient = [[Ingredient alloc] initWithWeight:100.0f andElement:object];
    
    valuesView.object = object;
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    [valuesView setValuesAccordingToWeight: currentWeight];
    
    //[self.subValuesView removeFromSuperview];
    [self.subValuesView addSubview: valuesView];
    
    [self.detailsButton setHidden:YES];
    
    [super viewDidLoad];
}


- (void)valueChanged:(double)newVal{
    [super valueChanged: newVal];
    [valuesView setValuesAccordingToWeight: newVal];
}


@end
