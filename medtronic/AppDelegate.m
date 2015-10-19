//
//  AppDelegate.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AppDelegate.h"
#import "MedtronicTabBarController.h"
#import "SQLiteController.h"
#import "Settings.h"
#import "Utils.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSArray * nibContents = [[NSBundle mainBundle] loadNibNamed:@"MedtronicTabBarController" owner:self options:nil];
    self.tabBarController = [nibContents objectAtIndex:0];
    
    self.window.rootViewController = self.tabBarController;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[Settings sharedSingleton] plusRunCounter];
    [self.window makeKeyAndVisible];
    
#if DEBUG
    [Utils addVersionNumberToView: self.window.rootViewController.view];
#endif
    
    [[SQLiteController sharedSingleton] createDatabaseIfNeeded];
    
    if ([Settings sharedSingleton].showConditions) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAcceptConditionsController" owner:self options:nil];
        UINavigationController * navConditions = [nib objectAtIndex:0];
        [self.tabBarController presentViewController: navConditions animated: NO completion:^{
            
        }];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[Settings sharedSingleton] save];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[Settings sharedSingleton] save];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
