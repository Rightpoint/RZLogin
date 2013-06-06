//
//  ViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13. Contributions and refactor by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginViewController.h"
#import "RZValidator.h"

#import "ViewController.h"
#import "MyCustomLoginViewController.h"
#import "MyCustomLoginEmailViewController.h"

// example: to support all three login-types, implement all three protocols
@interface ViewController () <RZLoginEmailViewControllerDelegate, RZLoginFacebookViewControllerDelegate, RZLoginTwitterViewControllerDelegate>

@end


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Choose Demo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - example usage

// Display sample login controller and use the default XIB
- (IBAction)loginUsingDefaultXIB:(id)sender
{
    // Create a login view-controller (with default configuration)
    RZLoginViewController *loginViewController = [[RZLoginViewController alloc] init];
    // Implement delegate methods for the protocol for each login-type you want to support
    loginViewController.emailLoginDelegate = self;
    loginViewController.facebookLoginDelegate = self;
    loginViewController.twitterLoginDelegate = self;
    
    // ok, simply present our login view-controller...
    [self.navigationController pushViewController:loginViewController animated:YES];
}

// Display sample login controller; using the default, included XIBs with plain buttons; allow login via email ONLY
- (IBAction)loginViaEmailOnlyUsingDefaultXIB:(id)sender
{
    // create a login view-controller (with default configuration); with only email-login supported
    RZLoginViewController *loginViewController = [[RZLoginViewController alloc] init];
    loginViewController.emailLoginDelegate = self; // note no other delegates (just email-login :)
    
    // ok, simply present our login view-controller...
    [self.navigationController pushViewController:loginViewController animated:YES];
}

// Display another sample login controller, with only email-login and Facebook login supported (no twitter)
// so we use a custom XIB with a background image, and no twitter button (and, naturally, no twitterLoginDelegate is specified)
- (IBAction)loginUsingCustomXIB:(id)sender
{
    MyCustomLoginViewController *loginViewController = [[MyCustomLoginViewController alloc] initWithNibName:@"MyCustomLoginViewController" bundle:nil];
    // For this example, our custom emailLoginViewController will be its own delegate
    loginViewController.facebookLoginDelegate = self;
    
    // for this example, let's also use a customized email-login view controller (and XIB) too ;)
    loginViewController.emailLoginViewController = [[MyCustomLoginEmailViewController alloc] initWithNibName:@"MyCustomLoginEmailViewController" bundle:nil];

    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - RZLoginFacebookViewControllerDelegate

- (NSString *)facebookAppId
{    
    return @"351055245000574";
}

- (void)loginViewController:(RZLoginViewController *)lvc didLoginWithFacebookWithToken:(NSString *)fbToken fullName:(NSString *)fullName userId:(NSString *)userId
{
    NSLog(@"%s: %@ - %@", __FUNCTION__, fullName, fbToken);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Login Succeeded"
                                    message:[NSString stringWithFormat:@"You have successfully logged-in with Facebook as: %@", fullName]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    });
}


#pragma mark - RZLoginTwitterViewControllerDelegate

- (NSString *)twitterConsumerKey
{
    return @"oZfeQ3lZtezzTqRWzjG0A";
}

- (NSString *)twitterConsumerSecret
{    
    return @"wSF4V5MO1hMzJiANpBbUTh3diIuadtEihfjYYTC6Y";
}

- (void)loginViewController:(RZLoginViewController *)lvc didLoginWithTwitterWithToken:(NSString *)twitterToken tokenSecret:(NSString *)tokenSecret username:(NSString *)username userId:(NSString *)userId
{
    NSLog(@"%s: %@ - %@ : %@", __FUNCTION__, username, twitterToken, tokenSecret);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Login Succeeded"
                                    message:[NSString stringWithFormat:@"You have successfully logged-in with Twitter as: %@", username]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    });
}


#pragma mark - RZLoginEmailViewControllerDelegate

// Invoked when the 'login' button is pressed, so you would authenticate
// the username/email-address and password values from the formInfo here.
- (void)loginViewController:(RZLoginEmailViewController *)loginViewController loginButtonClickedWithFormInfo:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);
    
    // Show alert-view with username that we logged-in
    // Normally you will validate the submitted email-address/password against a backend/web-service
    // and either dismiss the emailLoginController or show error-alert accordingly
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Login Succeeded"
                                    message:[NSString stringWithFormat:@"You have successfully logged-in with username: %@", [formInfo objectForKey:@"Email"]]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        // ok, dismiss our email-login view (note it might have been modal or on nav-stack)
        if( loginViewController.presentedViewController != nil ) {
            [loginViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popToViewController:loginViewController animated:YES]; // pop back to main view
        }
    });
}

// Invoked when the 'sign-up' button is pressed from the (optional) sign-up form, so you would
// implement here whatever business-logic is required to sign-up a new user for your application.
- (void)loginViewController:(RZLoginViewController *)loginViewController signUpButtonClickedWithFormInfo:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);

    // Show alert-view with email-address and password that we want to 'sign-up'
    // Normally you will validate the submitted email-address / password against a backend/web-service
    // and either dismiss the view-controller or show an error-alert accordingly
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Sign-up Succeeded"
                                    message:[NSString stringWithFormat:@"You have successfully signed-up with username: %@ and password: %@",
                                             [formInfo objectForKey:@"Email"], [formInfo objectForKey:@"Password"]]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
        // ok, dismiss our sign-up view (note it might have been modal or on nav-stack)
        if( loginViewController.presentedViewController != nil ) {
            [loginViewController dismissViewControllerAnimated:YES completion:nil];
        }
        [self.navigationController popToViewController:loginViewController animated:YES]; // and pop back to main view
    });
}


// Optional validator for email-address field on login form
- (RZValidator *)loginEmailAddressFieldValidator
{    
    return [RZValidator notEmptyValidatorForFieldName:@"Email address"];
}

// Optional validator for password field on login form
- (RZValidator *)loginPasswordFieldValidator
{    
    // Example usage of a custom validation-block (and failure message) when specifying a validator
    ValidationBlock validationBlock = ^BOOL(NSString *str) {
        return ([str length] > 0); // any attempted password is okay if not empty
    };
    RZValidator *validator = [[RZValidator alloc] initWithValidationBlock:validationBlock];
    validator.localizedViolationString = RZValidatorLocalizedString(@"password field must not be empty", @"Password field must not be empty.");
    return validator;
}

// optional validator for email-address field on sign-up form
- (RZValidator *)signUpEmailAddressFieldValidator {
    
    return [RZValidator emailAddressLooseValidator];
}

// Optional validator for password field on sign-up form
- (RZValidator *)signUpPasswordFieldValidator
{    
    // Password must be between 4 and 8 digits long and include at least one numeric digit    
    RZValidator *validator = [[RZValidator alloc] initWithValidationConditions:@{kFieldValidationRegexKey: @"^(?=.*\\d).{4,8}$"}];
    validator.localizedViolationString = RZValidatorLocalizedString(@"password strength:4-8/1",
                                                                    @"Password must be between 4 and 8 digits long, and include at least one numeric digit.");
    return validator;
}


@end
