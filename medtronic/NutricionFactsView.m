//
//  NutricionFactsView.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-04.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "NutricionFactsView.h"
#import "FoodParametres.h"

@implementation NutricionFactsView
@synthesize tableAll;

@synthesize
object, weight;
@synthesize wmText;
@synthesize procWbtText;
@synthesize wwText;
@synthesize wbtText;
@synthesize kcalText;
@synthesize proteinText;
@synthesize fatText;
@synthesize carbsText;
@synthesize fibreText,
realHeight;

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"NutricionFactsView" owner:self options:nil];
        CGRect fr = self.frame;
        if (self.tableAll.frame.size.height > fr.size.height) {
            [self setContentSize:CGSizeMake(self.frame.size.width, self.tableAll.frame.size.height)];
        }
        [self setBounces:YES];
        realHeight = self.tableAll.frame.size.height;
        //fr.size.height = self.tableAll.frame.size.height;
        //[self setFrame: fr];
        
        weight = 100.0f;
        
        [self addSubview: tableAll];
    }
    return self;
}

- (void) setValuesAccordingToWeight: (double) w{
    
    if (w == 0) {
        [self.wmText setText: [NSString stringWithFormat:@"%.1f",       0.0f]];
        [self.wbtText setText: [NSString stringWithFormat:@"%.1f",      0.0f]];
        [self.wwText setText: [NSString stringWithFormat:@"%.1f",       0.0f]];
        [self.procWbtText setText: [NSString stringWithFormat:@"%.0f %%", 0.0f]];
        [self.kcalText setText: [NSString stringWithFormat:@"%d kcal",  0]];
        [self.fatKcalText setText: [NSString stringWithFormat:@"%d kcal",  0]];
        [self.fibreText setText: [NSString stringWithFormat:@"%.1f g",  0.0f]];
        [self.fatText setText: [NSString stringWithFormat:@"%.1f g",    0.0f]];
        [self.carbsText setText: [NSString stringWithFormat:@"%.1f g",  0.0f]];
        [self.proteinText setText: [NSString stringWithFormat:@"%.1f g", 0.0f]];
        return;
    }
    
    weight = w;
    
    double ww = [FoodParametres countWWfromCarbs:object.carbs*weight/100.0f andFibre:object.fiber*weight/100.0f];
    double wbt = [FoodParametres countWBTfromProtein:object.protein*weight/100.0f andFat:object.fat*weight/100.0f];
    double wm = [FoodParametres countWMfromWW:ww andWBT:wbt];
    double wbt_proc = [FoodParametres countWbtPerc:wm forWBT:wbt];
    
//    NSLog(@"kcal: %f", object.kcal);
    
    [self.wmText setText: [NSString stringWithFormat:@"%.1f",       wm]];
    [self.wbtText setText: [NSString stringWithFormat:@"%.1f",      wbt]];
    [self.wwText setText: [NSString stringWithFormat:@"%.1f",       ww]];
    [self.procWbtText setText: [NSString stringWithFormat:@"%.0f %%", wbt_proc]];
    [self.kcalText setText: [NSString stringWithFormat:@"%.0f kcal",  (object.kcal*weight/100.0f)]];
    [self.fatKcalText setText: [NSString stringWithFormat:@"%.0f kcal",  (object.fat*FAT_KCAL*weight/100.0f)]];
    [self.fibreText setText: [NSString stringWithFormat:@"%.1f g",  (object.fiber*weight/100.0f)]];
    [self.fatText setText: [NSString stringWithFormat:@"%.1f g",    (object.fat*weight/100.0f)]];
    [self.carbsText setText: [NSString stringWithFormat:@"%.1f g",  (object.carbs*weight/100.0f)]];
    [self.proteinText setText: [NSString stringWithFormat:@"%.1f g", (object.protein*weight/100.0f)]];
}

@end
