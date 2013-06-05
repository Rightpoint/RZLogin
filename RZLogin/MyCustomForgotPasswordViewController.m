//
//  MyCustomForgotPasswordViewController.m
//  RZLogin
//
//  Created by Mordechai Rynderman on 6/5/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "MyCustomForgotPasswordViewController.h"

@interface MyCustomForgotPasswordViewController ()<RZForgotPasswordViewConrollerDelegate>

@end

@implementation MyCustomForgotPasswordViewController

@synthesize forgotPasswordEmailAddressFieldValidator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - RZForgotPasswordViewControllerDelegate

- (void)loginEmailViewController:(RZLoginEmailViewController *)lvc forgotPasswordEnteredWithFormInfo:(NSDictionary *)formInfo
{
    
    NSLog(@"Attempt password reset with info%@", formInfo);
    
}


@end
