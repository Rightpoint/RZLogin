//
//  RZSignUpViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSignUpViewController.h"

@interface RZSignUpViewController ()

@end

@implementation RZSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Determine whether or not we were presented modally
    if( self.presentingViewController == nil ) {
        // If NOT presented modally, remove the 'cancel' button
        [self.cancelButton removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupButtonAction:(id)sender
{
    RZValidator *failedValidator = [self validateForm];
    if(failedValidator == nil)
    {
        // ok, valid form, so call the delegate method to check login info
        [self.delegate loginViewController:self.loginViewController signUpButtonClickedWithFormInfo:[self formKeysAndValues]];
        
    } else {
        NSString *msg = (failedValidator.localizedViolationString ? failedValidator.localizedViolationString : @"Invalid sign-up information.");
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)cancelButtonAction:(id)sender
{
    // Should only be called when presented modally
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
