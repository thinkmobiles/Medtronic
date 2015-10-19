//
//  NutricionFactsAndIngredientsView.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-05.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "NutricionFactsAndIngredientsView.h"
#import "FoodParametres.h"

@implementation NutricionFactsAndIngredientsView
@synthesize allView;
@synthesize ingredientsTable;
@synthesize nutricionButton;
@synthesize ingredientsButton;
@synthesize subView,
delegate, nutricionFacts;

@synthesize 
mealDish;

- (id)initWithFrame:(CGRect)frame andElement: (MealDish *) el{
    self = [super initWithFrame:frame];
    if (self) {
        
        //ingredient = el;
        mealDish = el;
        //ingredients = [[NSArray alloc] initWithArray: mealDish.ingredients];
        
        
        [[NSBundle mainBundle] loadNibNamed:@"NutricionFactsAndIngredientsView" owner:self options:nil];

        [self setFrame: frame];
        [self.allView setFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview: allView];
        
        nutricionFacts = [[NutricionFactsView alloc] initWithFrame: CGRectMake(0, self.nutricionButton.frame.size.height, frame.size.width, self.ingredientsTable.frame.size.height)];
        nutricionFacts.autoresizingMask = UIViewAutoresizingNone;
        nutricionFacts.object = mealDish;
        nutricionFacts.frame = CGRectMake(0, self.nutricionButton.frame.size.height, frame.size.width, self.ingredientsTable.frame.size.height);
        [nutricionFacts setContentSize:CGSizeMake(self.subView.frame.size.width, nutricionFacts.realHeight)];
        
        [nutricionFacts setValuesAccordingToWeight: el.ingredientsWeight];
        
        [self.subView removeFromSuperview];
        [self.allView addSubview: nutricionFacts];
        
        buttonsExclusive = [[RadioButtonsGroup alloc] init];
        [buttonsExclusive addButton: self.nutricionButton];
        [buttonsExclusive addButton: self.ingredientsButton];
        [buttonsExclusive setInitialButtonSelected: self.nutricionButton.tag];
        buttonsExclusive.delegate = self;
        
        [ingredientsTable setHidden: YES];
        [nutricionFacts setHidden: NO];
        
        self.ingredientsTable.frame = CGRectMake(0, self.nutricionButton.frame.size.height, self.frame.size.width, self.allView.frame.size.height-self.nutricionButton.frame.size.height);
        self.nutricionFacts.frame = CGRectMake(0, self.nutricionButton.frame.size.height, self.frame.size.width, self.allView.frame.size.height-self.nutricionButton.frame.size.height);
        
        self.ingredientsTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.nutricionFacts.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.allView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


- (void)buttonSelected:(UIButton *)button{
    [ingredientsTable setHidden: (button == nutricionButton)];
    [nutricionFacts setHidden: !(button == nutricionButton)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Ingredient * ing = [mealDish.ingredients objectAtIndex: [indexPath row]];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailIngredientTableRow"];
    if (!cell) {
        NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"DetailIngredientTableRow" owner:self options:nil];
        cell = [arr  objectAtIndex:0];
    }
    [cell setBackgroundView: [[UIImageView alloc] initWithImage: ([indexPath row] % 2 == 1) ? [UIImage imageNamed:@"table_bkg_w.png"] : [UIImage imageNamed:@"table_bkg.png"]] ];
    [cell setSelectedBackgroundView: [[UIImageView alloc] initWithImage: ([indexPath row] % 2 == 1) ? [UIImage imageNamed:@"table_bkg_s_w.png"] : [UIImage imageNamed:@"table_bkg_s.png"]]];
    
    UILabel * label = (UILabel*)[cell viewWithTag:100];
    [label setText: ing.element.name];
    
    UILabel * weight = (UILabel*)[cell viewWithTag:101];
    
    // INSTYTUT - ZMIANA
    if (mealDish.type == DISH && !mealDish.isUserDefined) {
        [weight setText:@""];
    }
    else{
        [weight setText: [NSString stringWithFormat:@"%@ g", [FoodParametres doubleString:(ing.weight)]]];
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // INSTYTUT - ZMIANA
    if (mealDish.type == DISH && !mealDish.isUserDefined) {
    }
    else{
        Ingredient * ing = [mealDish.ingredients objectAtIndex: [indexPath row]];
        [delegate ingredientSelected: ing];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [mealDish.ingredients count];
}

- (void) setAllForWeight: (double) newW{
    //mealDish.ingredientsWeight = neww;
    [mealDish countAllNutricionFactsFor: newW];
    
    //mealDish.ingredientsWeight = newW;
    [ingredientsTable reloadData];
    
    [nutricionFacts setValuesAccordingToWeight: newW];
}

@end
