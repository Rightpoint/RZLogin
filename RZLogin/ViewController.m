//
//  ViewController.m
//  RZLogin
//
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginViewController.h"
#import "RZValidationInfo.h"

#import "ViewController.h"
#import "MyCustomLoginViewController.h"
#import "MyCustomLoginEmailViewController.h"

// to support all three login-types, impl all three protocols
//
@interface ViewController () <RZLoginEmailViewControllerDelegate, RZLoginFacebookViewControllerDelegate, RZLoginTwitterViewControllerDelegate>

// or, to support email-login only... impl only a single protocol
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

// display sample login controller; using default XIB with plain buttons
//
- (IBAction)loginUsingDefaultXIB:(id)sender;
{
    // create a login view-controller (with default configuration)
    // note the supported login-types depend on which protocol(s) are implemented by the delegate (self)
    //
    RZLoginViewController *loginController = [[RZLoginViewController alloc] initWithNibName:@"RZLoginViewController" bundle:nil];
    loginController.delegate = self;
    
    // FIXME: add a block-property to RZLoginEmailViewController protocol for the sign-up view-controller too
    // (i.e. just like we have now for the email password validator)
    //
    // validate the sign up fields with their tags as their identifying keys
    [loginController.signUpViewController setFormKeyType:RZFormFieldKeyTypeTag];
    
    // validate email
    [loginController.signUpViewController addFormValidationInfo:[RZValidationInfo emailValidationInfo] forTag:1];
    
    // validate that the password fields match
    [loginController.signUpViewController addFormValidationInfo:[RZValidationInfo validationInfoWithBlock:^(NSString *str) {
        
        NSString *prevPasswordFieldText = [(UITextField *)[loginController.signUpViewController.view viewWithTag:2] text];
        return [str isEqualToString:prevPasswordFieldText];
    }]
                                                     forTag:3];

    // ok, simply present our login v/c
    loginController.presentViewsAsModal = YES; // note for the 'default' example, we'll present views modally -- since default (email) XIB has 'cancel' button
    [self.navigationController pushViewController:loginController animated:YES];
}

// display another sample login controller; using a custom XIB with a background image (and no 'twitter' button)
//
- (IBAction)loginUsingCustomXIB:(id)sender;
{
    MyCustomLoginViewController *loginController = [[MyCustomLoginViewController alloc] initWithNibName:@"MyCustomLoginViewController" bundle:nil];
    loginController.delegate = self;
    
    // for this example, let's use a customized email-login view controller (and XIB) too ;)
    loginController.emailLoginViewController = [[MyCustomLoginEmailViewController alloc] initWithNibName:@"MyCustomLoginEmailViewController" bundle:nil];

    loginController.presentViewsAsModal = NO; // note present views with 'push' instead, since there's no 'cancel' button in sub-flow (e.g. 'email')
    [self.navigationController pushViewController:loginController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma -
#pragma mark - RZLoginFacebookViewControllerDelegate

- (NSString *)facebookAppId {
    
    return @"351055245000574";
}

- (void)didLoginWithFacebookWithToken:(NSString *)fbToken fullName:(NSString *)fullName userId:(NSString *)userId
{
    NSLog(@"%s: %@ - %@", __FUNCTION__, fullName, fbToken);
}


#pragma -
#pragma mark - RZLoginFacebookViewControllerDelegate

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


#pragma -
#pragma mark - RZLoginEmailViewControllerDelegate

- (ValidationBlock)loginPasswordValidator {
    
    ValidationBlock passwordValidator = ^BOOL(NSString *str) {
        
        return [str isEqualToString:@"password"]; // note: this would of course be replaced by your own validator ;)
    };
    return passwordValidator;
}

- (void)loginPressedWithFormInformation:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);
}

- (void)signUpPressedWithFormInformation:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);
}

@end
