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

@synthesize signUpViewController = _signUpViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Login";
    }
    return self;
}

#pragma mark - validators for login with email and signup forms

// since these RZLoginEmailViewControllerDelegate properties are optional,
// these local convenience getters check if implemented; else return nil (or a default value)
//
- (RZValidator *)loginEmailAddressFieldValidator {
    if( [self.delegate respondsToSelector:@selector(loginEmailAddressFieldValidator)] ) {
        return self.delegate.loginEmailAddressFieldValidator;
    } else {
        return nil;
    }
}

- (RZValidator *)loginPasswordFieldValidator {
    if( [self.delegate respondsToSelector:@selector(loginPasswordFieldValidator)] ) {
        return self.delegate.loginPasswordFieldValidator;
    } else {
        return nil;
    }
}

- (RZValidator *)signUpEmailAddressFieldValidator {
    if( [self.delegate respondsToSelector:@selector(signUpEmailAddressFieldValidator)] ) {
        return self.delegate.signUpEmailAddressFieldValidator;
    } else {
        return nil;
    }
}

- (RZValidator *)signUpPasswordFieldValidator {
    if( [self.delegate respondsToSelector:@selector(signUpPasswordFieldValidator)] ) {
        return self.delegate.signUpPasswordFieldValidator;
    } else {
        return nil;
    }
}

- (BOOL)isSignupAllowed {
    if( [self.delegate respondsToSelector:@selector(isSignupAllowed)] ) {
        return [self.delegate isSignupAllowed]; // defer to (optional) delegate property
    } else {
        return YES; // by default, we allow sign-up
    }
}

- (BOOL)shouldPresentAsModal {
    if( [self.delegate respondsToSelector:@selector(shouldPresentAsModal)] ) {
        return [self.delegate shouldPresentAsModal]; // defer to (optional) delegate property
    } else {
        return NO; // by default, let's have our nav-controller 'push' the email-login form (i.e. NOT modally)
    }
}

- (BOOL)shouldPresentSignupFormAsModal {
    if( [self.delegate respondsToSelector:@selector(shouldPresentSignupFormAsModal)] ) {
        return [self.delegate shouldPresentSignupFormAsModal]; // defer to (optional) delegate property
    } else {
        return YES; // by default, let's present the sign-up form modally
    }
}

- (RZSignUpViewController *)signUpViewController {
    if( (_signUpViewController == nil)  && self.isSignupAllowed ) {
        // if sign-up is allowed, create and configure its view-controller too; note also it shares the same delegate
        self.signUpViewController = [[RZSignUpViewController alloc] initWithNibName:@"RZSignUpViewController" bundle:nil];
        self.signUpViewController.delegate = self.delegate;
    }
    return _signUpViewController;
}

- (void)setSignUpViewController:(RZSignUpViewController *)signUpViewController {
    _signUpViewController = signUpViewController;
    
    // and stash a reference to the (main) login view-controller (for delegate callbacks)
    _signUpViewController.loginViewController = self.loginViewController;
}

#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup email login form validation (note we're using each field's placeholder-text as keys)
    [self setFormKeyType:RZFormFieldKeyTypePlaceholderText];
    
    // validate email-address field using a validator provided by the delegate; else default to a standard email-validator
    if( [self loginEmailAddressFieldValidator] != nil ) {
        [self addValidator:[self loginEmailAddressFieldValidator] forFieldWithPlaceholderText:@"Email"];
    } else {
        [self addValidator:[RZValidator emailAddressValidator] forFieldWithPlaceholderText:@"Email"];
    }
    
    // validate password field using a validator provided by the delegate; else default to a 'isNotEmpty' validator
    if( [self loginPasswordFieldValidator] != nil ) {
        [self addValidator:[self loginPasswordFieldValidator] forFieldWithPlaceholderText:@"Password"];
    } else {
        [self addValidator:[RZValidator notEmptyValidator] forFieldWithPlaceholderText:@"Password"];
    }

    if( self.isSignupAllowed ) {
        // setup sign-up form validation (note we're using each field's 'tag' as the key)
        [self.signUpViewController setFormKeyType:RZFormFieldKeyTypeTag];
        
        // validate email-address field using a validator provided by the delegate; else default to a standard email-validator
        if( [self signUpEmailAddressFieldValidator] != nil ) {
            [self.signUpViewController addValidator:[self signUpEmailAddressFieldValidator] forFieldWithTag:1];
        } else {
            [self.signUpViewController addValidator:[RZValidator emailAddressValidator] forFieldWithTag:1];
        }
        
        // validate password field using a validator provided by the delegate; else default to a 'isNotEmpty' validator
        if( [self signUpPasswordFieldValidator] != nil ) {
            [self.signUpViewController addValidator:[self signUpPasswordFieldValidator] forFieldWithTag:2];
        } else {
            [self.signUpViewController addValidator:[RZValidator notEmptyValidator] forFieldWithTag:2];
        }
        
        // and finally, validate that the (two) password fields match
        // (note first password field has a view-tag of '2' and second has tag of '3')
        ValidationBlock validationBlock = ^BOOL(NSString *str) {
            NSString *prevPasswordFieldText = [(UITextField *)[self.signUpViewController.view viewWithTag:2] text];
            return [str isEqualToString:prevPasswordFieldText];
        };
        RZValidator *validator = [[RZValidator alloc] initWithValidationBlock:validationBlock];
        validator.localizedViolationString = RZValidatorLocalizedString(@"passwords must match", @"Passwords must match.");
        [self.signUpViewController addValidator:validator forFieldWithTag:3]; // add validator to second 'password' field
        
    } else {
        self.signUpViewController = nil;
    }

    // remove the sign-up button depending on options
    if( self.signUpViewController == nil ) {
        [self.signUpButton removeFromSuperview];
    }
    
    // determine whether or not we were presented 'modally'...
    if( self.presentingViewController == nil ) {
        // if we were NOT presented modally, remove the (unnecessary) 'cancel' button
        [self.cancelButton removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated]; // show the nav-bar
    [super viewWillAppear:animated];
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
        [self.delegate loginViewController:self.loginViewController loginButtonClickedWithFormInfo:[self formKeysAndValues]];
        
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
    if(self.signUpViewController != nil)
    {
        if( self.shouldPresentSignupFormAsModal ) {
            [self presentViewController:self.signUpViewController animated:YES completion:nil];
        } else {
            [self.navigationController pushViewController:self.signUpViewController animated:YES];
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
