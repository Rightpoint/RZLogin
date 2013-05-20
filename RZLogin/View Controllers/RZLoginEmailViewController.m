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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if( self.signUpController == nil ) {
        // we don't want to allow the option for 'sign-up'...
        [self.signUpButton removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed
{
    //validateForm returns a dictionary of keys corresponding to each field and values corresponding to the
    //text in the fields. It returns nil if the form is not valid.
    NSDictionary *formDict = [self validateForm];
    if(formDict != nil)
    {
        //Notify the delegate that it should process the login information.
        [self.loginDelegate loginPressedWithFormInformation:formDict];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid login information." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

//A cancel button will only be present and connected to this outlet if this controller is presented modally.
- (IBAction)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpPressed
{
    if(self.signUpController != nil)
    {
        [self presentViewController:self.signUpController animated:YES completion:nil];
    }
}

@end
