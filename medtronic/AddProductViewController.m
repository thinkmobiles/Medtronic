//
//  AddProductViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-27.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AddProductViewController.h"
#import "FoodParametres.h"
#import "AbstractMedtronicViewController.h"
#import "AbstractMedtronicStackViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "FoodParametres.h"
#import "Utils.h"
#import "Product.h"
#import "UIAlertView+Blocks.h"

@implementation AddProductViewController
@synthesize nameText;
@synthesize chooseCategoryButton;
@synthesize categoryLabel;
@synthesize kcalText;
@synthesize proteinText;
@synthesize fatText;
@synthesize carbsText;
@synthesize fibreText, addProdDelegate;


#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"Dodaj produkt"];
    [self addOkButton];
    [self addCancelButton];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    addProdDelegate = nil;
    caloriesRechecked = NO;
    
    [self.view setFrame: CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-44-20)];
    
//    NSLog(@"view frame: %f,%f %fx%f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewDidUnload{
    [self setNameText:nil];
    [self setChooseCategoryButton:nil];
    [self setKcalText:nil];
    [self setProteinText:nil];
    [self setFatText:nil];
    [self setCarbsText:nil];
    [self setFibreText:nil];
    [self setCategoryLabel:nil];
    [super viewDidUnload];
}

- (IBAction)chooseCategoryClicked:(id)sender {
    
    if (self.lastTextField) {
        [self.lastTextField resignFirstResponder];
    }
    
    if (!catsView) {
        catsView = [[ChooseCategoriesViewController alloc] initWithNibName:@"ChooseCategoriesViewController" andType: PRODUCT];
        catsView.howMany = 1;
        [catsView setDelegate: self];
        above = [[MedtronicAboveNavigationController alloc] initWithNibName: @"MedtronicAboveNavigationController" bundle:nil];
        above.rootView = catsView;
    }
    
    if (catChosen) {
        
        AbstractMedtronicStackViewController * stack = catsView.myStack;
        for (ChooseCategoriesViewController * vc in stack.controllersStack) {
            vc.preChosenCategories = [NSArray arrayWithObject: catChosen];
        }
    }
    [[catsView myRealNavigationItem] setTitle:@"Kategorie potraw"];
    
    [self.myStack.delegate pushControllerAbove:above withPrevious:self];
}

- (IBAction)okAdd:(id)sender{
    
    NSString * error = nil;
    if ((error = [self validate]) != nil) {
        [self showError: error];
        return;
    }
    
    int caloriesCounted = [FoodParametres countCaloriesFromCarbs: [carbsText.text doubleValue] protein: [proteinText.text doubleValue] fat:[fatText.text doubleValue]];
    
    NSLog(@"Count: %d", caloriesCounted);
    
    // now let's check calories calculations
    if (!caloriesRechecked && caloriesCounted != [kcalText.text intValue]) {
        
        NSString * answer = @"Nie, produkt jest gotowy";
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            answer = @"Nie poprawiaj";
        }
        
        [UIAlertView showDialogWithTitle: @"" message:@"Czy wpisano poprawnie ilość kalorii? Chcesz sprawdzić wprowadzone dane?" okButton: answer cancelButton:@"Popraw" handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
           
            caloriesRechecked = YES;
            if (buttonIndex != alertView.cancelButtonIndex) {
                [self finalAddProduct];
            }
            
        }];
    }
    else{
        [self finalAddProduct];
    }
}

- (void) finalAddProduct{
    int next = [[SQLiteController sharedSingleton] getNextElementId];
    
    NSMutableString * name = [NSMutableString stringWithFormat:@"%@", nameText.text];
    
    double ww = [FoodParametres countWWfromCarbs: [carbsText.text doubleValue] andFibre: [fibreText.text doubleValue]];
    double wbt = [FoodParametres countWBTfromProtein: [proteinText.text doubleValue] andFat: [fatText.text doubleValue]];
    double wm = [FoodParametres countWMfromWW: ww andWBT: wbt];
    
    NSMutableString * addSql = [NSMutableString stringWithFormat:@"INSERT INTO element VALUES ("];
    [addSql appendFormat:@"'%d',", next]; // id
    [addSql appendFormat:@"'%@',", [Utils uppercaseSentence: name]];   // name
    [addSql appendFormat:@"'%f',", [fatText.text doubleValue] ];   // fat
    [addSql appendFormat:@"'%f',", [fibreText.text doubleValue]];   // fiber
    [addSql appendFormat:@"'%f',", [carbsText.text doubleValue]];   // carbs
    [addSql appendFormat:@"'%f',", [kcalText.text floatValue]];   // kcal
    [addSql appendFormat:@"'%f',", [proteinText.text doubleValue]];   // protein
    [addSql appendFormat:@"'%f',", ww];   // ww
    [addSql appendFormat:@"'%f',", wbt];   // wbt
    [addSql appendFormat:@"'%f',", wm];   // wm
    [addSql appendFormat:@"'%f',", [FoodParametres countWbtPerc:wm forWBT:wbt]];   // wbt_proc
    [addSql appendFormat:@"'%d',", PRODUCT];   // type
    [addSql appendFormat:@"'0',"];   // is_favourite
    [addSql appendFormat:@"null,"];   // weight_cooked
    [addSql appendFormat:@"'1',"];   // is_user_defined
    [addSql appendFormat:@"null,"];   // img_name
    [addSql appendFormat:@"date('now'),"];   // date_created
    [addSql appendFormat:@"null);"];   // weight_meal
    
    [[SQLiteController sharedSingleton] commitTransaction: addSql];
    
    // let's add category
    NSString * catSql = [NSString stringWithFormat:@"INSERT INTO element_has_category VALUES ('%d','%d')", next, catChosen.theid];
    [[SQLiteController sharedSingleton] commitTransaction: catSql];
    
    [self showMessage:@"Produkt został dodany"];
    [(UIViewController*)self.myStack.delegate dismissViewControllerAnimated:YES completion:nil];
    
    Product * element = [[Product alloc] initWithId:next andName:[Utils uppercaseSentence: name]];
    [addProdDelegate productWasAdded: element];
}

- (NSString *) validate{
    if ([nameText.text length] == 0) {
        return @"Podaj nazwę produktu";
    }
    else if([kcalText.text length] == 0){
        return @"Podaj ilość kalorii";
    }
    else if([proteinText.text length] == 0){
        return @"Podaj ilość białka na 100g produktu";
    }
    else if([fatText.text length] == 0){
        return @"Podaj ilość tłuszczu na 100g produktu";
    }
    else if([carbsText.text length] == 0){
        return @"Podaj ilość węglowodanów na 100g produktu";
    }
    else if([fibreText.text length] == 0){
        return @"Podaj ilość błonnika na 100g produktu";
    }
    else if(catChosen == nil){
        return @"Wybierz jedną z kategorii dla produktu. Na liście kategorii możesz dodać nową kategorię/podkategorię";
    }
    return nil;
}

- (void)cancel:(id)sender{
    [(UIViewController*)self.myStack.delegate dismissViewControllerAnimated:YES completion:nil];
}

- (void)chosenCategories:(NSArray *)chosen{
    catChosen = [chosen objectAtIndex:0];
    [self.categoryLabel setText: catChosen.name];
    [self.myStack.delegate popControllerAbove];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
    [super textFieldDidBeginEditing: textField];
}



@end
