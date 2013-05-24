//
//  RZLoginEmailViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginEmailViewController.h"

@interface RZLoginEmailViewController ()

@end

@implementation RZLoginEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.presentSignUpFormAsModal = YES;    // by default, let's present the sign-up form modally
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // remove the sign-up button depending on options
    if( self.signUpController == nil ) {
        [self.signUpButton removeFromSuperview];
    }
    
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

- (IBAction)loginButtonAction:(id)sender
{
    RZValidator *failedValidator = [self validateForm];
    if(failedValidator == nil)
    {
        // ok, valid form, so call the delegate method to check login info
        [self.loginDelegate loginPressedWithFormInformation:[self formKeysAndValues]];
        
    } else {
        NSString *msg = (failedValidator.localizedViolationString ? failedValidator.localizedViolationString : @"Invalid login information.");
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)signupButtonAction:(id)sender
{
    if(self.signUpController != nil)
    {
        if( self.shouldPresentSignupFormAsModal ) {
            [self presentViewController:self.signUpController animated:YES completion:nil];
        } else {
            [self.navigationController pushViewController:self.signUpController animated:YES];
        }
    }
}

- (IBAction)cancelButtonAction:(id)sender
{
    // note a cancel button will only be present if this controller was presented modally...
    // so we can simply dismiss ourselves here :)
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
