//
//  RZForgotPasswordViewController.m
//  RZLogin
//
//  Created by Mordechai Rynderman on 6/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZForgotPasswordViewController.h"
#import "RZValidator.h"

@interface RZForgotPasswordViewController () <RZForgotPasswordViewConrollerDelegate>

@end

@implementation RZForgotPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Forgot Password";
    }
    return self;
}

#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addValidator:[self forgotPasswordEmailAddressFieldValidator] forFieldWithPlaceholderText:((UITextField *)self.formFields[0]).placeholder];
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

- (BOOL)supportsLoginTypeEmail
{
    return YES;
}

- (BOOL)supportsLoginTypeFacebook
{
    return YES;
}

- (BOOL)supportsLoginTypeTwitter
{
    return NO;
}

- (IBAction)emailEnteredButtonAction:(id)sender
{
    RZValidator *failedValidator = [self validateForm];
    if (failedValidator == nil)
    {
        [self.delegate loginEmailViewController:self.loginEmailViewController forgotPasswordEnteredWithFormInfo:[self formKeysAndValues]];
        
        [[self.formFields objectAtIndex:0] resignFirstResponder];
    }
    else
    {
        NSString *msg = (failedValidator.localizedViolationString ? failedValidator.localizedViolationString : @"invalid email address");
        [[[UIAlertView alloc] initWithTitle:@"Reset Failed"
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
#pragma mark - validators for login with email and signup forms

// Because the RZForgotPasswordViewControllerDelegate properties are optional,
// this local convenience getter checks if implemented; else return nil (or a default value)

- (RZValidator *)forgotPasswordEmailAddressFieldValidator
{
    if( [self.delegate respondsToSelector:@selector(forgotPasswordEmailAddressFieldValidator)] ) {
        return self.delegate.forgotPasswordEmailAddressFieldValidator;
    } else {
        return nil;
    }
}

# pragma mark - RZForgotPasswordViewControllerDelegate

- (void)loginEmailViewController:(RZLoginEmailViewController *)lvc forgotPasswordEnteredWithFormInfo:(NSDictionary *)formInfo
{
    NSLog(@"in RZForgot forgotPasswordEnteredWithFormInfo called");
}

@end
