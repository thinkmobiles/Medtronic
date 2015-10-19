//
//  AbstractDetailViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractDetailViewController.h"
#import "SQLiteController.h"
#import "FoodParametres.h"
#import "Settings.h"
#import "RectUtils.h"

@implementation AbstractDetailViewController
@synthesize itdWeightLabel;
@synthesize notEditableImage;
@synthesize notEditableLabel;
@synthesize detailsButton;
@synthesize weightSliderView;
@synthesize weightTextField;
@synthesize changeWeightButton;


@synthesize
object;
@synthesize mainLabel,
subValuesView;

- (id)initWithNibName:(NSString *)nibNameOrNil andObject: (MedtronicObject*) obj{
    self = [super initWithNibName:nibNameOrNil bundle: nil];
    if (self) {
        object = (Element *)obj;
        //ingredient = [[Ingredient alloc] initWithWeight:100.0f andElement:object];
        currentWeight = 100.0f;
    }
    return self;
}

- (IBAction)detailsButtonClicked:(id)sender {
}

- (IBAction)closeSliderClicked:(id)sender {
    [self changeWeightClicked:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.mainLabel setText: object.name];
    [self prepareButtonsOnBar];
    
    [self.weightTextField setText: [FoodParametres doubleString: currentWeight]];
    [self.weightSliderView setHidden:YES];
    [self.mySlider setValue: currentWeight];
    
    [self.mySlider setMaximumValue: [Settings sharedSingleton].maxWeight];
    [self.mySlider setMinimumValue:0.1f];
    
    self.sliderDelegate = self;
}

- (IBAction)changeWeightClicked:(id)sender {
    self.changeWeightButton.selected = !self.changeWeightButton.selected;
    [self.weightSliderView setHidden: !self.changeWeightButton.selected];
    [self.weightTextField setUserInteractionEnabled: self.changeWeightButton.selected];
    //[imageBelow setHidden: !self.changeWeightButton.selected];

    int sizeToChange = self.changeWeightButton.frame.size.height+3;
    self.subValuesView.frame = [RectUtils rect: self.subValuesView.frame offsetYSmallerHeight: self.changeWeightButton.selected ? sizeToChange : -sizeToChange];
    
    /*
    CGRect rect = self.subValuesView.frame;
    int sizeToChange = self.changeWeightButton.frame.size.height+3;
    rect.origin.y += (self.changeWeightButton.selected ? sizeToChange : -sizeToChange);
    rect.size.height += (self.changeWeightButton.selected ? -sizeToChange : sizeToChange);
    [self.subValuesView setFrame:rect];
    
    [valuesView setFrame: CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [valuesView setContentSize: CGSizeMake(rect.size.width, valuesView.realHeight)];
     */
}

- (IBAction)addToFav:(id)sender{

    BOOL ok = NO;
    ok = [[SQLiteController sharedSingleton] commitTransaction:[NSString stringWithFormat: @"UPDATE element SET is_favourite=%d WHERE id=%d", object.isFavourite ? 0 : 1, object.theid]];
    if (ok) {
        object.isFavourite = !object.isFavourite;
        [favouriteButton setImage: [UIImage imageNamed: object.isFavourite ? @"fav_button_rem.png" : @"fav_button.png"] forState:UIControlStateNormal];
        [favouriteButton setImage: [UIImage imageNamed: object.isFavourite ? @"fav_button_rem_s.png" : @"fav_button_s.png"] forState:UIControlStateHighlighted];
    }
}

- (IBAction)removeElement:(id)sender{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Uwaga" message: [NSString stringWithFormat:@"Czy na pewno chcesz usunąć z bazy '%@'?", object.name] delegate:self cancelButtonTitle:@"Anuluj" otherButtonTitles:@"Usuń", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        NSString * errorCheck = [self checkIfCanDelete];
        
        if (errorCheck) {
            [self showError: [NSString stringWithFormat:@"Nie można usunąć '%@' ponieważ jest on wykorzystywany w składzie %@", object.name, errorCheck]];
            return;
        }
        
        NSString * removeSql = [self removeMe];
        //NSString * removeSql = [NSString stringWithFormat:@"DELETE FROM element_has_category WHERE id_element=%d; DELETE FROM element WHERE id=%d;", object.theid, object.theid];
        
        if ([[SQLiteController sharedSingleton] commitTransaction: removeSql]) {
            [self showMessage: @"Element został usunięty"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        else{
            [self showError:@"Nie udało się usunąć elementu"];
        }
    }
}

- (NSString *) removeMe{
    return [NSString stringWithFormat:@"DELETE FROM element_has_category WHERE id_element=%d; DELETE FROM element WHERE id=%d;", object.theid, object.theid];
}

- (void) prepareButtonsOnBar{
    
    int allW = 0;
    
    favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favouriteButton setImage: [UIImage imageNamed: object.isFavourite ? @"fav_button_rem.png" : @"fav_button.png"] forState:UIControlStateNormal];
    [favouriteButton setImage: [UIImage imageNamed: object.isFavourite ? @"fav_button_rem_s.png" : @"fav_button_s.png"] forState:UIControlStateHighlighted];
    
    [favouriteButton setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"fav_button.png"].size.width, [UIImage imageNamed:@"fav_button.png"].size.height)];
    [favouriteButton addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];

    
    allW += favouriteButton.frame.size.width;
    
    
    if (object.isUserDefined) {
        removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeButton setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
        [removeButton setBackgroundImage: [UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
        
        [removeButton setTitle:@"Usuń" forState:UIControlStateNormal];
        [removeButton.titleLabel setFont: [UIFont boldSystemFontOfSize:12]];
        [removeButton.titleLabel setTextColor: [UIColor whiteColor]];
        
        [removeButton setFrame: CGRectMake(favouriteButton.frame.size.width+2, 0, [UIImage imageNamed:@"small_button.png"].size.width, [UIImage imageNamed:@"small_button.png"].size.height)];
        
        [removeButton addTarget:self action:@selector(removeElement:) forControlEvents:UIControlEventTouchUpInside];
        
        allW += removeButton.frame.size.width;
        allW += 2;
    } 
    
    UIView * customView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, allW, [UIImage imageNamed:@"fav_button.png"].size.height)];
    [customView setBackgroundColor: [UIColor clearColor]];
    [customView addSubview: favouriteButton];
    if (removeButton) {
        [customView addSubview: removeButton];
    }
        
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: customView];
    
    if (self.navItem) {
         [self.navItem setRightBarButtonItem: plus];
    }
    else{
         [self.navigationItem setRightBarButtonItem: plus];
    }
}

- (NSString *)checkIfCanDelete{
    return nil;
}

- (void)viewDidUnload {
    [self setChangeWeightButton:nil];
    //[self setWeightLabel:nil];
    [self setDetailsButton:nil];
    [self setWeightSliderView:nil];
    [self setWeightTextField:nil];
    //[self setImageBelow:nil];
    [self setItdWeightLabel:nil];
    [self setNotEditableImage:nil];
    [self setNotEditableLabel:nil];
    [super viewDidUnload];
}

- (void)valueChanged:(double)newVal{
    
    currentWeight = newVal;
    [self.weightTextField setText: [FoodParametres doubleString: newVal]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    currentWeight = [textField.text doubleValue];
    [self.mySlider setValue: currentWeight animated:YES];
    [self valueChanged: currentWeight];
}


@end
