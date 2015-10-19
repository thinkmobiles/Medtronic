//
//  AddIngredientWithWeightViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-28.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"
#import "Ingredient.h"

@protocol AddIngredientWithWeightDelegate <NSObject>

- (void) ingredientToAdd: (Ingredient *) newOne; 

@end

@interface AddIngredientWithWeightViewController : AbstractMedtronicViewController
<UITextFieldDelegate, UISliderDelegate>{
    
    Ingredient * inToAdd;
    Element * element;
    
    id<AddIngredientWithWeightDelegate> delegate;
}

@property (nonatomic, retain) id<AddIngredientWithWeightDelegate> delegate;
@property (nonatomic, retain) Element * element;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *weightTextField;

@end
