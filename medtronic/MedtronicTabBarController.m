//
//  MedtronicTabBarController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "MedtronicTabBarController.h"
#import "PopupsManager.h"
#import "MedtronicConstants.h"
#import "RectUtils.h"

@implementation UINavigationController (LightBar)

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end


@implementation MedtronicTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImage * logoImage = [UIImage imageNamed:@"logo.png"];
    UIButton * logoButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 320, logoImage.size.height)];
    [logoButton setImage: logoImage forState: UIControlStateNormal];
    [logoButton setImage: logoImage forState: UIControlStateSelected];
    [logoButton setImage: logoImage forState: UIControlStateHighlighted];
    [logoButton addTarget: self action:@selector(logoClicked:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: logoButton];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        logoButton.frame = CGRectOffset(logoButton.frame, 0, 20);
        
        UIView * fakeStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        fakeStatusBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview: fakeStatusBar];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    else{
        logoButton.frame = CGRectOffset(logoButton.frame, 0, 20);

    }
    
    [[UITabBar appearance] setSelectionIndicatorImage: [UIImage imageNamed:@"select_bg"]];
    [[UITabBar appearance] setBackgroundImage: [[UIImage imageNamed:@"tab_button"] resizableImageWithCapInsets: UIEdgeInsetsZero resizingMode: UIImageResizingModeTile]];
//    [[UITabBar appearance] setTranslucent:NO];
    
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor lightGrayColor], UITextAttributeTextColor, nil] forState: UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor lightBlueColor], UITextAttributeTextColor, nil] forState: UIControlStateSelected];
    
    NSArray * unselectedImages = @[@"posilki_icon", @"potrawy_icon", @"produkty_icon", @"medtronic_icon"];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        for (int i = 0; i < unselectedImages.count; ++i) {
            UITabBarItem * item = self.tabBar.items[i];
            item.image = [[UIImage imageNamed: unselectedImages[i]] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [[UIImage imageNamed: [NSString stringWithFormat:@"%@_s", (NSString *)unselectedImages[i]]] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        }
    }
    else{
        for (int i = 0; i < unselectedImages.count; ++i) {
            UITabBarItem * item = self.tabBar.items[i];
            [item setFinishedSelectedImage: [UIImage imageNamed: [NSString stringWithFormat:@"%@_s", (NSString *)unselectedImages[i]] ] withFinishedUnselectedImage: [UIImage imageNamed: unselectedImages[i]]];
        }
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        for (UIViewController * contr in self.viewControllers) {
            contr.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    
    // tutorial commented
    /*
    popupsManager = [[PopupsManager alloc] init];
    [popupsManager showPopups];
    */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)logoClicked:(id)buttonSender{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: MEDTRONIC_SITE_URL]];
}

@end
