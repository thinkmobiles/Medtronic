//
//  ChooseCategoriesViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-29.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicListViewController.h"
#import "CategoriesViewController.h"
#import "RadioButtonsGroup.h"

@protocol CategoriesSelectionDelegate <NSObject>

- (void) chosenCategories: (NSArray *) chosen;

@end


@interface ChooseCategoriesViewController : CategoriesViewController{

    id<CategoriesSelectionDelegate> delegate;

    int howMany;
    NSArray * preChosenCategories;
}

@property int howMany;
@property (nonatomic, retain) id<CategoriesSelectionDelegate> delegate;
@property (nonatomic, retain) NSArray * preChosenCategories;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *categoryLabel;

@property (nonatomic, strong) NSMutableDictionary * chosenCategoriesDict;
@property (nonatomic, strong) NSMutableArray * chosenCategoriesArray;

- (void) buttonSelected:(UIButton *)button;

@end
