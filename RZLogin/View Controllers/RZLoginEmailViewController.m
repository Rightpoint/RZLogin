//
//  RZLoginEmailViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginEmailViewController.h"

#define kEmailPlaceholderText @"Email"
#define kPasswordPlaceholderText @"Password"

@interface RZLoginEmailViewController ()<RZLoginEmailViewControllerDelegate>

@end

@implementation RZLoginEmailViewController

@synthesize signUpViewController = _signUpViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Login";
    }
    return self;
}

#pragma mark - validators for login with email and signup forms

// Because the RZLoginEmailViewControllerDelegate properties are optional,
// these local convenience getters check if implemented; else return nil (or a default value)

- (RZValidator *)loginEmailAddressFieldValidator {
    if( [self isEqual:self.delegate] )
    {
        return nil;
    }
    if( [self.delegate respondsToSelector:@selector(loginEmailAddressFieldValidator)] ) {
        return self.delegate.loginEmailAddressFieldValidator;
    }
    return nil;
}

- (RZValidator *)loginPasswordFieldValidator {
    if( [self isEqual:self.delegate] ) {
        return nil;
    }
    if ( [self.delegate respondsToSelector:@selector(loginPasswordFieldValidator)] ) {
        return self.delegate.loginPasswordFieldValidator;
    }
    return nil;
}

- (RZValidator *)signUpEmailAddressFieldValidator {
    if( [self isEqual:self.delegate] ){
        return nil;
    }
    if( [self.delegate respondsToSelector:@selector(signUpEmailAddressFieldValidator)] ) {
        return self.delegate.signUpEmailAddressFieldValidator;
    }
    else {
        return nil;
    }
}

- (RZValidator *)signUpPasswordFieldValidator {
    if( [self isEqual:self.delegate] ) {
        return nil;
    }
    if( [self.delegate respondsToSelector:@selector(signUpPasswordFieldValidator)] ) {
        return self.delegate.signUpPasswordFieldValidator;
    } else {
        return nil;
    }
}

- (BOOL)isSignupAllowed {
    if( [self isEqual:self.delegate] ) {
        return YES;
    }
    if( [self.delegate respondsToSelector:@selector(isSignupAllowed)] ) {
        return [self.delegate isSignupAllowed]; // defer to (optional) delegate property
    } else {
        return YES; // by default, we allow sign-up
    }
}

- (BOOL)isForgotPasswordAllowed {
    if( [self.delegate respondsToSelector:@selector(isForgotPasswordAllowed)] ) {
        return [self.delegate isForgotPasswordAllowed]; // defer to (optional) delegate property
    } else {
        return NO; // by default, we allow forgot password
    }
}

- (BOOL)shouldPresentAsModal {
    if( [self isEqual:self.delegate] ) {
        return NO; // by default, let's have our nav-controller 'push' the email-login form (i.e. NOT modally)
    }
    if( [self.delegate respondsToSelector:@selector(shouldPresentAsModal)] ) {
        return [self.delegate shouldPresentAsModal]; // defer to (optional) delegate property
    }
    return NO;
}

- (BOOL)shouldPresentSignupFormAsModal {
    
    if( [self isEqual:self.delegate] ) {
        return NO; // by default, let's have our nav-controller 'push' the email-login form (i.e. NOT modally)
    }
    if( [self.delegate respondsToSelector:@selector(shouldPresentSignupFormAsModal)] ) {
        return [self.delegate shouldPresentSignupFormAsModal]; // defer to (optional) delegate property
    }
    return NO;
}

- (NSString *)emailPlaceholderString
{
    return kEmailPlaceholderText;
}
- (NSString *)passwordPlaceholderString
{
    return kPasswordPlaceholderText;
}

- (RZSignUpViewController *)signUpViewController {
    
    // if sign-up is allowed, create and/or configure its view-controller too; note it shares the same delegate
    if( self.isSignupAllowed )
    {
        if( _signUpViewController == nil ) {
            // create the default sign-up form
            self.signUpViewController = [[RZSignUpViewController alloc] initWithNibName:@"RZSignUpViewController" bundle:nil];
            _signUpViewController.delegate = self.delegate;
        }
        
        // setup sign-up form validation (note we're using each field's 'tag' as the key)
        [_signUpViewController setFormKeyType:RZFormFieldKeyTypeTag];
        
        // validate email-address field using a validator provided by the delegate; else default to a standard email-validator
        if( [self signUpEmailAddressFieldValidator] != nil ) {
            [_signUpViewController addValidator:[self signUpEmailAddressFieldValidator] forFieldWithTag:1];
        } else {
            [_signUpViewController addValidator:[RZValidator emailAddressLooseValidator] forFieldWithTag:1];
        }
        
        // validate password field using a validator provided by the delegate; else default to a 'isNotEmpty' validator
        if( [self signUpPasswordFieldValidator] != nil ) {
            [_signUpViewController addValidator:[self signUpPasswordFieldValidator] forFieldWithTag:2];
        } else {
            [_signUpViewController addValidator:[RZValidator notEmptyValidator] forFieldWithTag:2];
        }
        
        // and finally, validate that the (two) password fields match
        // (note first password field has a view-tag of '2' and second has tag of '3')
        ValidationBlock validationBlock = ^BOOL(NSString *str) {
            NSString *prevPasswordFieldText = [(UITextField *)[self.signUpViewController.view viewWithTag:2] text];
            return [str isEqualToString:prevPasswordFieldText];
        };
        RZValidator *validator = [[RZValidator alloc] initWithValidationBlock:validationBlock];
        validator.localizedViolationString = RZValidatorLocalizedString(@"passwords must match", @"Passwords must match.");
        [_signUpViewController addValidator:validator forFieldWithTag:3]; // add validator to second 'password' field
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
        [self addValidator:[self loginEmailAddressFieldValidator] forFieldWithPlaceholderText:self.emailPlaceholderString];
    } else {
        [self addValidator:[RZValidator emailAddressLooseValidator] forFieldWithPlaceholderText:self.emailPlaceholderString];
    }
    
    // validate password field using a validator provided by the delegate; else default to a 'isNotEmpty' validator
    if( [self loginPasswordFieldValidator] != nil ) {
        [self addValidator:[self loginPasswordFieldValidator] forFieldWithPlaceholderText:self.passwordPlaceholderString];
    } else {
        [self addValidator:[RZValidator notEmptyValidator] forFieldWithPlaceholderText:self.passwordPlaceholderString];
    }
    
    // remove the sign-up button depending on options
    if( self.signUpViewController == nil ) {
        [self.signUpButton removeFromSuperview];
    }
    
    // remove the sign-up button depending on options
    if( self.isForgotPasswordAllowed == NO ) {
        [self.forgotPasswordButton removeFromSuperview];
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
    }
    else {
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

- (IBAction)forgotPasswordButtonAction:(id)sender
{
    [self.navigationController pushViewController:self.forgotPasswordViewController animated:YES];
}


#pragma mark - RZLoginEmailViewController delegate

- (void)loginViewController:(RZLoginViewController *)lvc loginButtonClickedWithFormInfo:(NSDictionary *)formInfo
{
    NSLog(@"login button clicked with form info %@", formInfo);
}
@end
