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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpPressed
{
    // validateForm returns a dictionary of keys corresponding to each field and values corresponding to the
    // text in the fields. It returns nil if the form is not valid.
    NSDictionary *formDict = [self validateForm];
    if(formDict != nil)
    {
        // form fields are valid: so notify the delegate that it should process the login information
        [self.loginDelegate signUpPressedWithFormInformation:formDict];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Invalid sign up information."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

// A cancel button will only be present and connected to this outlet if this controller is presented modally.
- (IBAction)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
