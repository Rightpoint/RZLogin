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

// alternately, to support email-login only... implement only the single protocol, for example:
//
// @interface ViewController () <RZLoginEmailViewControllerDelegate>

@end


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // any custom initialization goes here...
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - example usage

// display sample login controller; using the default, included XIBs with plain buttons
- (IBAction)loginUsingDefaultXIB:(id)sender
{
    // create a login view-controller (with default configuration)
    // note the supported login-types depend on which protocol(s) are implemented by the delegate (self)
    RZLoginViewController *loginController = [[RZLoginViewController alloc] init];
    loginController.delegate = self;
        
    // ok, simply present our login view-controller...
    // note for the 'default' example here, we'll present views *modally* (since our default email-login XIB shows a 'cancel' button)
    loginController.presentViewsAsModal = YES;
    [self.navigationController pushViewController:loginController animated:YES];
}

// display another sample login controller;
// using a custom XIB with a background image (and no 'twitter' button)
- (IBAction)loginUsingCustomXIB:(id)sender
{
    MyCustomLoginViewController *loginController = [[MyCustomLoginViewController alloc] initWithNibName:@"MyCustomLoginViewController" bundle:nil];
    loginController.delegate = self;
    
    // for this example, let's also use a customized email-login view controller (and XIB) too ;)
    loginController.emailLoginViewController = [[MyCustomLoginEmailViewController alloc] initWithNibName:@"MyCustomLoginEmailViewController" bundle:nil];

    loginController.presentViewsAsModal = NO; // note present views with 'push' instead, since there's no 'cancel' button in our (custom) email-login form
    [self.navigationController pushViewController:loginController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - RZLoginFacebookViewControllerDelegate

- (NSString *)facebookAppId {
    
    return @"351055245000574";
}

- (void)didLoginWithFacebookWithToken:(NSString *)fbToken fullName:(NSString *)fullName userId:(NSString *)userId
{
    NSLog(@"%s: %@ - %@", __FUNCTION__, fullName, fbToken);
}


#pragma mark - RZLoginTwitterViewControllerDelegate

- (NSString *)twitterConsumerKey {
    
    return @"oZfeQ3lZtezzTqRWzjG0A";
}

- (NSString *)twitterConsumerSecret {
    
    return @"wSF4V5MO1hMzJiANpBbUTh3diIuadtEihfjYYTC6Y";
}

- (void)didLoginWithTwitterWithToken:(NSString *)twitterToken tokenSecret:(NSString *)tokenSecret username:(NSString *)username userId:(NSString *)userId
{
    NSLog(@"%s: %@ - %@ : %@", __FUNCTION__, username, twitterToken, tokenSecret);
}


#pragma mark - RZLoginEmailViewControllerDelegate

// Invoked when the 'login' button is pressed, so you would authenticate
// the username/email-address and password values from the formInfo here.
- (void)loginPressedWithFormInformation:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);
}

// Invoked when the 'sign-up' button is pressed from the (optional) sign-up form, so you would
// implement here whatever business-logic is required to sign-up a new user for your application.
- (void)signUpPressedWithFormInformation:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);
}


// optional validator for email-address field on login form
- (RZValidator *)loginEmailAddressFieldValidator {
    
    return [RZValidator notEmptyValidatorForFieldName:@"Email address"];
}

// optional validator for password field on login form
- (RZValidator *)loginPasswordFieldValidator {
    
    // example usage of a custom validation-block (and failure message) when specifying a validator
    ValidationBlock validationBlock = ^BOOL(NSString *str) {
        
        return ([str length] > 0); // any *attempted* password is okay, if not empty
    };
    RZValidator *validator = [[RZValidator alloc] initWithValidationBlock:validationBlock];
    validator.localizedViolationString = RZValidatorLocalizedString(@"password field must not be empty", @"Password field must not be empty.");
    return validator;
}

// optional validator for email-address field on sign-up form
- (RZValidator *)signUpEmailAddressFieldValidator {
    
    return [RZValidator emailAddressValidator];
}

// optional validator for password field on sign-up form
- (RZValidator *)signUpPasswordFieldValidator {
    
    // this example: password must be between 4 and 8 digits long and include at least one numeric digit    
    RZValidator *validator = [[RZValidator alloc] initWithValidationConditions:@{kFieldValidationRegexKey: @"^(?=.*\\d).{4,8}$"}];
    validator.localizedViolationString = RZValidatorLocalizedString(@"password strength:4-8/1",
                                                                    @"Password must be between 4 and 8 digits long, and include at least one numeric digit.");
    return validator;
}


@end
