//
//  ViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "ViewController.h"
#import "RZLoginViewController.h"
#import "RZValidationInfo.h"

@interface ViewController () <RZLoginButtonsViewControllerDelegate, RZLoginEmailViewControllerDelegate, RZSignUpViewControllerDelegate>

@end

@implementation ViewController

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

//Display sample login controller.
- (void)loginPressed
{
    //Initialize with all login types and test social media keys.
    RZLoginViewController *loginController = [[RZLoginViewController alloc] initWithLoginTypes:RZLoginTypeFacebook | RZLoginTypeTwitter | RZLoginTypeEmail
                                                                                 facebookAppID:@"351055245000574"
                                                                            twitterConsumerKey:@"oZfeQ3lZtezzTqRWzjG0A"
                                                                         twitterConsumerSecret:@"wSF4V5MO1hMzJiANpBbUTh3diIuadtEihfjYYTC6Y"
                                                                                 loginDelegate:self];
    
    //Validate the email login fields with placeholder text keys.
    [loginController.emailLoginController setFormKeyType:RZFormFieldKeyTypePlaceholderText];
    
    //Validate email.
    [loginController.emailLoginController addFormValidationInfo:[RZValidationInfo emailValidationInfo] forPlaceholderText:@"Email"];
    
    //Validate password with a block.
    [loginController.emailLoginController addFormValidationInfo:[RZValidationInfo validationInfoWithBlock:^(NSString *str){
        return [str isEqualToString:@"password"];
    }] forPlaceholderText:@"Password"];
    
    
    //Validate the sign up fields with their tags as their identifying keys.
    [loginController.signUpController setFormKeyType:RZFormFieldKeyTypeTag];
    
    //Validate email.
    [loginController.signUpController addFormValidationInfo:[RZValidationInfo emailValidationInfo] forTag:1];
    
    //Validate that the password fields match.
    [loginController.signUpController addFormValidationInfo:[RZValidationInfo validationInfoWithBlock:^(NSString *str) {
        
        NSString *prevPasswordFieldText = [(UITextField *)[loginController.signUpController.view viewWithTag:2] text];
        return [str isEqualToString:prevPasswordFieldText];
    }] forTag:3];
    
    [self presentViewController:loginController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RZLoginButtonsViewControllerDelegate

- (void)didLoginWithFacebookWithToken:(NSString *)fbToken fullName:(NSString *)fullName userID:(NSString *)userID
{
    NSLog(@"%@ - %@", fullName, fbToken);
}

- (void)didLoginWithTwitterWithToken:(NSString *)twitterToken tokenSecret:(NSString *)tokenSecret username:(NSString *)username userID:(NSString *)userID
{
    NSLog(@"%@ - %@ : %@", username, twitterToken, tokenSecret);
}

#pragma mark - RZLoginEmailViewControllerDelegate

- (void)loginPressedWithFormInformation:(NSDictionary *)formInfo
{
    
}

#pragma mark - RZSignUpViewControllerDelegate

- (void)signUpPressedWithFormInformation:(NSDictionary *)formInfo
{
    
}

@end
