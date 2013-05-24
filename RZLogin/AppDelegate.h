//
//  AppDelegate.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RZLoginViewController.h"
#import "MyCustomLoginViewController.h"
#import "MyCustomLoginEmailViewController.h"

#define exampleShowLoginViewControllerAsRootVC          0 // for this example app: use '1' to show RZLoginViewController as root-v/c
#define exampleShowCustomLoginViewControllerAsRootVC    0 // alternately, for this example app: use '1' to use MyCustomLoginViewController
                                                          // set both #defines to '0' to choose between custom and standard login-views

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

#if exampleShowLoginViewControllerAsRootVC || exampleShowCustomLoginViewControllerAsRootVC
@property (strong, nonatomic) RZLoginViewController *loginController;
#endif

@end
