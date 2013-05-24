//
//  AppDelegate.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
#if exampleShowLoginViewControllerAsRootVC
    self.loginController = [[RZLoginViewController alloc] init];
    self.loginController.delegate = self.viewController; // note we use this here as our delegate, even though we're not displaying it
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginController];
    
#elif exampleShowCustomLoginViewControllerAsRootVC
    self.loginController = [[MyCustomLoginViewController alloc] initWithNibName:@"MyCustomLoginViewController" bundle:nil];
    self.loginController.emailLoginViewController = [[MyCustomLoginEmailViewController alloc] initWithNibName:@"MyCustomLoginEmailViewController" bundle:nil];
    self.loginController.delegate = self.viewController; // note we use this here as our delegate, even though we're not displaying it
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginController];
    
#else // normal demo, with both custom and standard login-views (i.e. choose via buttons in ViewController.xib)
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
#endif
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
