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
        // Any custom initialization goes here.
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
    
    // FIXME: determine whether or not we were presented 'modally'...
    // and remove the 'cancel' button if we were not (since we have 'back' button)
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed
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

// A cancel button will only be present and connected to this outlet if this controller is presented modally.
- (IBAction)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil]; // note FIXME above, in viewDidLoad
}

- (IBAction)signUpPressed
{
    if(self.signUpController != nil)
    {
        [self presentViewController:self.signUpController animated:YES completion:nil];
    }
}

@end
