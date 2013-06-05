//
//  MyCustomLoginEmailViewController.m
//  RZLogin
//
//  Created by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "MyCustomLoginEmailViewController.h"
#import "MyCustomForgotPasswordViewController.h"
#import "RZLoginEmailViewControllerDelegate.h"

@interface MyCustomLoginEmailViewController ()<RZLoginEmailViewControllerDelegate>

@end

@implementation MyCustomLoginEmailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.forgotPasswordViewController = [[MyCustomForgotPasswordViewController alloc] initWithNibName:@"MyCustomForgotPasswordViewController" bundle:nil];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // dispose of any resources that can be recreated
}

- (BOOL)isSignupAllowed
{
    return NO;
}

- (BOOL)isForgotPasswordAllowed
{
    return YES;
}

#pragma mark - RZLoginEmailViewControllerDelegate

- (void)loginViewController:(RZLoginEmailViewController *)loginViewController loginButtonClickedWithFormInfo:(NSDictionary *)formInfo
{
    NSLog(@"Attempt to login with %@", formInfo);
}



@end
