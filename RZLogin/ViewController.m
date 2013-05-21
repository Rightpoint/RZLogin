//
//  ViewController.m
//  RZLogin
//
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "ViewController.h"
#import "RZLoginViewController.h"
#import "RZValidationInfo.h"

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
    
    //
    // FIXME: this 'form-validation' stuff doesn't appear to be working (for email-login and sign-up forms)
    //
    
    // validate the email login fields with placeholder text keys
    [loginController.emailLoginViewController setFormKeyType:RZFormFieldKeyTypePlaceholderText];
    
    // validate email
    [loginController.emailLoginViewController addFormValidationInfo:[RZValidationInfo emailValidationInfo] forPlaceholderText:@"Email"];
    
    // validate password with a block
    [loginController.emailLoginViewController addFormValidationInfo:[RZValidationInfo validationInfoWithBlock:^(NSString *str){
        return [str isEqualToString:@"password"];
    }] forPlaceholderText:@"Password"];
    
    
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
    [self.navigationController pushViewController:loginController animated:YES];
}

// display another sample login controller; using a custom XIB with a background image (and no 'twitter' button)
//
- (IBAction)loginUsingCustomXIB:(id)sender;
{
    RZLoginViewController *loginController = [[RZLoginViewController alloc] initWithNibName:@"MyCustomLoginViewController" bundle:nil];
    loginController.delegate = self;
    
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

- (void)loginPressedWithFormInformation:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);
}

- (void)signUpPressedWithFormInformation:(NSDictionary *)formInfo
{
    NSLog(@"%s: %@", __FUNCTION__, formInfo);
}

@end
