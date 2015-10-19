//
//  ProductsViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ProductsViewController.h"
#import "ElementsListViewController.h"
#import "CategoriesViewController.h"
#import "AddProductViewController.h"
#import "ProductsAndCategoriesListViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "Product.h"
#import "DetailProductViewController.h"
#import "MedtronicConstants.h"

@implementation ProductsViewController


#pragma mark - View lifecycle

- (void)viewDidLoad{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (!addDelegate) {
        isInside = YES;
    }
    //isInside = YES;
    [super viewDidLoad];
    [self setTitle:@"Produkty"];
    [self addPlusButton];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productWasAdded:) name:@"Product_added" object:nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!addDelegate) {
        //self.navigationController.view.frame = CGRectMake(0.0, im.size.height, 320.0, 480.0-50-im.size.height); 
    }
}

- (void) addPlusButton{
    plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setBackgroundImage: [UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"small_button_s.png"] forState:UIControlStateHighlighted];
    
    [plusButton setTitle:@"Dodaj" forState:UIControlStateNormal];
    [plusButton.titleLabel setFont: [UIFont boldSystemFontOfSize:12]];
    [plusButton.titleLabel setTextColor: [UIColor whiteColor]];
    
    [plusButton setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"small_button.png"].size.width, [UIImage imageNamed:@"small_button.png"].size.height)];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: plusButton];
    [plusButton addTarget:self action:@selector(plusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.navItem) {
        [self.navItem setRightBarButtonItem: plus];
    }
    else{
        [self.navigationItem setRightBarButtonItem: plus];
    }
}

- (void)initControllers{
    
    controllersArray = [[NSMutableArray alloc] init];
    
    [controllersArray addObject: [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: PRODUCT andMainFilter: ALL]] ];
    
    ProductsAndCategoriesListViewController * next = [[ProductsAndCategoriesListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: PRODUCT];
    next.depth = 1;
    next.parentCategory = nil;
    next.addDelegate = addDelegate;
    
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: next]];
    
    [controllersArray addObject:  [[AbstractMedtronicStackViewController alloc] initWitRootController: [[ElementsListViewController alloc] initWithNibName:@"AbstractMedtronicListViewController" andType: PRODUCT andMainFilter: FAVOURITE]]];
    
    if (self.addDelegate) {
        [self setAddDelegates];
    }
}

- (void)plusButtonClicked:(id)sender{
    
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAddProductController" owner:nil options:nil];
    UINavigationController * navController = [arr objectAtIndex:0];
    
    MedtronicAboveNavigationController * above = [[navController viewControllers] objectAtIndex:0];
    above.rootView = [[AddProductViewController alloc] initWithNibName:@"AddProductViewController" bundle:nil];
    
    [[self myRealNavigationController] presentViewController: navController animated: YES completion:nil];
    
    ((AddProductViewController *)above.rootView).addProdDelegate = self;
}

- (void)productWasAdded:(Product *)element{
    if (element) {
        DetailProductViewController * productView = [[DetailProductViewController alloc] initWithNibName:@"AbstractDetailViewController" andObject: element];
        productView.isInside = self.isInside;
        [[self myRealNavigationController] pushViewController: productView animated:YES];
    }
}


@end
