//
//  IngredientsView.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "IngredientsView.h"
#import "FoodParametres.h"
#import "SQLiteController.h"
#import "IngredientsSliderTableRow.h"

#define NAME_LABEL 100
#define WEIGHT_EDIT 101
#define DELETE_BUTTON 102

@implementation IngredientsView
@synthesize allKcal;
@synthesize allWW;
@synthesize allWBT;
@synthesize allFibre;
@synthesize proteinKcal;
@synthesize proteinWW;
@synthesize proteinWBT;
@synthesize fatKcal;
@synthesize fatWW;
@synthesize fatWBT;
@synthesize twoKcal;
@synthesize twoWW;
@synthesize twoWBT;
@synthesize carbsKcal;
@synthesize carbsWW;
@synthesize carbsWBT;
@synthesize detaildButton;
@synthesize detailsView;

@synthesize ingredients;
@synthesize table;
@synthesize allInfoView,
textFieldDelegate, delegate, currentChangeIngredient, changeDelegate,
proteinValue, allValue, allFibreValue, fatValue, carbsValue,
allFatValue, allCarbsValue, allProteinValue;


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"IngredientsView" owner:self options:nil];
        //self = [arr objectAtIndex:0];
        [self setFrame: frame];
        
        [self.table setFrame: CGRectMake(0, 0, frame.size.width, frame.size.height-allInfoView.frame.size.height)];
        [self addSubview: self.table];
        
        [self.allInfoView setFrame: CGRectMake(0, self.table.frame.size.height, self.frame.size.width, self.allInfoView.frame.size.height)];
        [self addSubview: self.allInfoView];
        
        ingredients = [[NSMutableArray alloc] init];
        
        textFieldDelegate = nil;
        detailed = NO;
        currentChangeIngredient = nil;
        
        [self initAllValues];
    }
    return self;
}

- (void) initAllValues{

    proteinValue.kcal = 0;
    proteinValue.ww = 0;
    proteinValue.wbt = 0;
    
    fatValue.kcal = 0;
    fatValue.ww = 0;
    fatValue.wbt = 0;
    
    twoValue.kcal = 0;
    twoValue.ww = 0;
    twoValue.wbt = 0;
    
    carbsValue.kcal = 0;
    carbsValue.ww = 0;
    carbsValue.wbt = 0;
    
    allValue.kcal = 0;
    allValue.ww = 0;
    allValue.wbt = 0;
    allFibreValue = 0;
    
    allFatValue = 0;
    allCarbsValue = 0;
    allProteinValue = 0;
}


- (id)initDetailsWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"IngredientsView" owner:self options:nil];
        //self = [arr objectAtIndex:0];
        [self setFrame: frame];
        
        [self.table setFrame: CGRectMake(0, 0, frame.size.width, frame.size.height-allInfoView.frame.size.height-detailsView.frame.size.height)];
        [self addSubview: self.table];
        
        [self.detailsView setFrame: CGRectMake(0, self.table.frame.size.height, self.frame.size.width, self.detailsView.frame.size.height)];
        [self addSubview: self.detailsView];
        
        [self.allInfoView setFrame: CGRectMake(0, self.table.frame.size.height+self.detailsView.frame.size.height, self.frame.size.width, self.allInfoView.frame.size.height)];
        [self addSubview: self.allInfoView];
        
        [detaildButton setHidden:YES];
        
        ingredients = [[NSMutableArray alloc] init];
        detailed = YES;
        textFieldDelegate = nil;
        currentChangeIngredient = nil;
        
        [self initAllValues];
    }
    return self;
}

- (id)initOnlyDetailsWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"IngredientsView" owner:self options:nil];
        //self = [arr objectAtIndex:0];
        [self setFrame: frame];
                
        [self.detailsView setFrame: CGRectMake(0, 0, self.frame.size.width, self.detailsView.frame.size.height)];
        [self addSubview: self.detailsView];
        
        [self.allInfoView setFrame: CGRectMake(0, self.detailsView.frame.size.height, self.frame.size.width, self.allInfoView.frame.size.height)];
        [self addSubview: self.allInfoView];
        
        [detaildButton setHidden:YES];
        
        ingredients = [[NSMutableArray alloc] init];
        detailed = YES;
        textFieldDelegate = nil;
        currentChangeIngredient = nil;
        
        [self initAllValues];
    }
    return self;
}

- (void) addNewElement: (Ingredient *) el{
    
    for (Ingredient * singleOne in ingredients) {
        if (singleOne.element.theid == el.element.theid) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Składnik znajduje się już na liście" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
            return;
        }
    }
    
    NSString * sel = [NSString stringWithFormat:@"SELECT * FROM ELEMENT WHERE ELEMENT.id = %d", el.element.theid];
    Element * element = (Element*)[[SQLiteController sharedSingleton] execSelect:sel fillObject: el.element];

    Ingredient * ingredient = [[Ingredient alloc] initWithWeight:el.weight andElement:element];
    
    [ingredients addObject: ingredient];
    [self countForAllIngredients];
    if (table) {
        [table reloadData];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Ingredient * theOne = [ingredients objectAtIndex: [indexPath row]];
    IngredientsSliderTableRow * cell = (IngredientsSliderTableRow*)[tableView dequeueReusableCellWithIdentifier:@"IngredientSliderTableRow"];
    
    if (!cell) {
        cell = [[IngredientsSliderTableRow alloc] initWithIngredient: theOne];
        [cell setMyTextDelegate: textFieldDelegate];
    }
    else{
        [cell setIngredient: theOne];
    }
    cell.tag = [indexPath row];
    cell.delegate = self;
    
    if (theOne == currentChangeIngredient) {
        [cell setSliderShown: YES];
    }
    else{
        [cell setSliderShown: NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    IngredientsSliderTableRow * cell = (IngredientsSliderTableRow*)[tableView cellForRowAtIndexPath: indexPath];
    if (cell.hasSliderShown) {
        return 36+50;
    }*/
    
    Ingredient * ing = [ingredients objectAtIndex: [indexPath row]];
    if (ing == currentChangeIngredient) {
        return 36+50;
    }
    return 36;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ingredients count];
}


- (IBAction) removeIngredient: (id) sender{
    UIButton * button = (UIButton *)sender;
    int index = button.superview.tag;
    
    NSLog(@"remove: %d", index);
    
    [ingredients removeObjectAtIndex: index];
    [self countForAllIngredients];
    
    if (table) {
        [table reloadData];
    }
}

- (IBAction)showDetailsClicked:(id)sender {
    [delegate showDetails: ingredients];
}

- (void) countForAllIngredients{
    [self initAllValues];
    
    for (Ingredient * ing in ingredients) {
        
        //NSLog(@"ingredient: %@", ing.element.name);
        
        allValue.kcal   += (ing.scalingFactor*ing.weight*ing.element.kcal/100.0f);
        allValue.ww     += (ing.scalingFactor*ing.weight*ing.element.ww/100.0f);
        allValue.wbt    += (ing.scalingFactor*ing.weight*ing.element.wbt/100.0f);
        
        allFibreValue   += (ing.scalingFactor*ing.weight*ing.element.fiber/100.0f);
        allFatValue     += (ing.scalingFactor*ing.weight*ing.element.fat/100.0f);
        allProteinValue += (ing.scalingFactor*ing.weight*ing.element.protein/100.0f);
        allCarbsValue   += (ing.scalingFactor*ing.weight*ing.element.carbs/100.0f);
        
        proteinValue.ww += 0.0f;
        proteinValue.wbt += (ing.scalingFactor*ing.weight*[FoodParametres countWBTfromProtein: ing.element.protein andFat:0.0f]/100.0f);
        
        //NSLog(@"protein kcal: %f", ((ing.scalingFactor*4.0f*ing.weight*ing.element.protein)/100.0f));
        
        proteinValue.kcal += (ing.scalingFactor*PROTEIN_KCAL*ing.weight*ing.element.protein)/100.0f;
        
        fatValue.ww += 0.0f;
        fatValue.wbt += (ing.scalingFactor*ing.weight*[FoodParametres countWBTfromProtein: 0.0f andFat: ing.element.fat]/100.0f);
        
        fatValue.kcal += (ing.scalingFactor*FAT_KCAL*ing.weight*ing.element.fat)/100.0f;
        
        //NSLog(@"fat kcal: %f", ((ing.scalingFactor*8.8f*ing.weight*ing.element.fat)/100.0f));
        
        twoValue.ww = (proteinValue.ww+fatValue.ww);
        twoValue.wbt = (proteinValue.wbt+fatValue.wbt);
        
//        NSLog(@"two kcal: %f", (proteinValue.kcal+fatValue.kcal));
        twoValue.kcal = ((int)proteinValue.kcal+(int)fatValue.kcal);
        
        carbsValue.ww += (ing.scalingFactor*ing.weight*[FoodParametres countWWfromCarbs:ing.element.carbs andFibre:ing.element.fiber]/100.0f);
        carbsValue.wbt += 0.0f;
        
        carbsValue.kcal += (ing.scalingFactor*CARBS_KCAL*ing.weight*ing.element.carbs)/100.0f;
    
        //NSLog(@"carbs kcal: %f", ((ing.scalingFactor*4.0f*ing.weight*ing.element.carbs)/100.0f));
    }
    
    //NSLog(@"carbs kcal: %f", carbsValue.kcal);
    //NSLog(@"two kcal: %f", (twoValue.kcal));
    //NSLog(@"real: %f", (twoValue.kcal+carbsValue.kcal));
    
//    float perOne = allValue.kcal/17.0f;
//    carbsValue.kcal = perOne*4.0f;
//    fatValue.kcal = perOne*9.0f;
//    proteinValue.kcal = perOne*4.0f;
//    twoValue.kcal = proteinValue.kcal + fatValue.kcal;
    
    [self.allKcal setText:  /*[FoodParametres doubleString: allValue.kcal]*/[NSString stringWithFormat:@"%.0f", allValue.kcal]];
    [self.allWW setText:    [FoodParametres doubleString: allValue.ww]];
    [self.allWBT setText:   [FoodParametres doubleString: allValue.wbt]];
    [self.allFibre setText: [NSString stringWithFormat:@"%@ g", [FoodParametres doubleString: allFibreValue]]];
    
    if (detailed) {
        [self.proteinKcal setText:  /*[FoodParametres doubleString:proteinValue.kcal]*/ [NSString stringWithFormat:@"%.0f", proteinValue.kcal]];
        [self.proteinWW setText:    [FoodParametres doubleString: proteinValue.ww]];
        [self.proteinWBT setText:   [FoodParametres doubleString: proteinValue.wbt]];
        
        [self.fatKcal setText:  /*[FoodParametres doubleString: fatValue.kcal]*/[NSString stringWithFormat:@"%.0f", fatValue.kcal]];
        [self.fatWW setText:    [FoodParametres doubleString: fatValue.ww]];
        [self.fatWBT setText:   [FoodParametres doubleString: fatValue.wbt]];
        
        [self.twoKcal setText:  /*[FoodParametres doubleString:twoValue.kcal]*/[NSString stringWithFormat:@"%.0f", twoValue.kcal]];
        [self.twoWW setText:    [FoodParametres doubleString: twoValue.ww]];
        [self.twoWBT setText:   [FoodParametres doubleString: twoValue.wbt]];
        
        [self.carbsKcal setText:  /*[FoodParametres doubleString:carbsValue.kcal]*/[NSString stringWithFormat:@"%.0f", carbsValue.kcal]];
        [self.carbsWW setText:    [FoodParametres doubleString: carbsValue.ww]];
        [self.carbsWBT setText:   [FoodParametres doubleString: carbsValue.wbt]];
    }
}

- (void) ingredientTableRowShowChange: (Ingredient *) ing {
    //currentChangeIngredient = nil;
    //[table reloadData];
    currentChangeIngredient = ing;
    [table reloadData];
}

- (void) ingredientTableRowDelete: (Ingredient *) ing{
    [ingredients removeObject: ing];
    [table reloadData];
    [self countForAllIngredients];
    [changeDelegate ingredientsChanged];
}

- (void) ingredientTableRowWeightChanged: (Ingredient *) ing{
    [self countForAllIngredients];
    [changeDelegate ingredientsChanged];
}

@end
