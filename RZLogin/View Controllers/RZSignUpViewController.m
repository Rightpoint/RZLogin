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

    // determine whether or not we were presented 'modally'...
    if( self.presentingViewController == nil ) {
        // if we were NOT presented modally, remove the (unnecessary) 'cancel' button
        [self.cancelButton removeFromSuperview];
    }
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
        [self.loginDelegate signUpPressedWithFormInformation:[self formKeysAndValues]];
        
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
    // note a cancel button will only be present if this controller was presented modally...
    // so we can simply dismiss ourselves here :)
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
