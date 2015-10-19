//
//  NutricionFactsView.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-04.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"

@interface NutricionFactsView : UIScrollView{
    Element * object;
    double weight;
    float realHeight;
}

@property (nonatomic, retain) Element * object;
@property double weight;
@property float realHeight;

@property (strong, nonatomic) IBOutlet UIView *tableAll;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wmText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *procWbtText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wwText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *wbtText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *kcalText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *proteinText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fatText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *carbsText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *fibreText;
@property (weak, nonatomic) IBOutlet UILabel *fatKcalText;

- (void) setValuesAccordingToWeight: (double) w;

@end
