//
//  RZLoginButtonsViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginButtonsViewController.h"
#import "RZSocialLoginManager.h"
#import <Accounts/Accounts.h>

@interface RZLoginButtonsViewController () <UIActionSheetDelegate>

//Property to store the list of Twitter accounts on the device for use with the account selection action sheet.
@property (nonatomic, strong) NSArray *twitterAccounts;

//Alert the user to a login error for social media logins.
- (void)giveAlertForError:(NSError *)error socialNetwork:(NSString *)socialNetworkName;

//Functions for different login buttons being pressed.
- (void)loginWithFacebookPressed;
- (void)loginWithTwitterPressed;
- (void)loginWithEmailPressed;
- (void)signupWithEmailPressed;

@end

@implementation RZLoginButtonsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //If Facebook login is one of the options and no Facebook app ID is provided, throw an exception.
    if((self.loginTypes & RZLoginTypeFacebook) && !(self.facebokAppID && self.facebokAppID.length > 0))
    {
        [NSException raise:@"Facebook app id invalid" format:@"Please set facebookAppId before presenting the login controller."];
    }
    
    //If Facebook login is one of the options and no consumer key or no consumer secret is provided, throw an exception.
    if((self.loginTypes & RZLoginTypeTwitter) && !((self.twitterConsumerKey.length > 0 && self.twitterConsumerKey) && (self.twitterConsumerSecret.length > 0 && self.twitterConsumerSecret)))
    {
        [NSException raise:@"Twitter app information invalid" format:@"Please set twitterConsumerKey and twitterConsumerSecret before presenting the login controller."];
    }
    
    //Add the Facebook login action to the facebook login button. Remove the button if Facebook is not specified as a login option.
    if(self.loginTypes & RZLoginTypeFacebook && self.fbLoginButton)
    {
        [self.fbLoginButton addTarget:self action:@selector(loginWithFacebookPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(self.fbLoginButton)
    {
        [self.fbLoginButton removeFromSuperview];
    }
    
     //Add the Twitter login action to the facebook login button. Remove the button if Twitter is not specified as a login option.
    if(self.loginTypes & RZLoginTypeTwitter && self.twitterLoginButton)
    {
        [self.twitterLoginButton addTarget:self action:@selector(loginWithTwitterPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(self.twitterLoginButton)
    {
        [self.twitterLoginButton removeFromSuperview];
    }
    
     //Add the email login and signup actions to the appropriate buttons. Remove the buttons if email is not specified as a login option.
    if(self.loginTypes & RZLoginTypeEmail && self.emailLoginButton)
    {
        [self.emailLoginButton addTarget:self action:@selector(loginWithEmailPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.emailSignUpButton addTarget:self action:@selector(signupWithEmailPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(self.emailLoginButton)
    {
        [self.emailLoginButton removeFromSuperview];
        [self.emailSignUpButton removeFromSuperview];
    }
}

//Alert the user to a login error for social media logins such as forgetting to enable permissions or login in the Settings app.
- (void)giveAlertForError:(NSError *)error socialNetwork:(NSString *)socialNetworkName
{
    //This method is called from completion blocks that may not be on the main thread, so dispatch the UIAlertView to the main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.code == 6 || error.code == 7 || error == nil)
        {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                        message:[NSString stringWithFormat:@"Make sure you have logged in and given permission to this app to access your %@ account in the Settings app.", socialNetworkName]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                        message:[NSString stringWithFormat:@"There was a problem loggin in with %@.", socialNetworkName]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Social Login Methods

//Method called when the Facebook login button is pressed.
- (void)loginWithFacebookPressed
{
    [[RZSocialLoginManager defaultManager] loginToFacebookWithAppID:self.facebokAppID completion:^(NSString *token, NSString *fullName, NSString *userID, NSError *error) {
        if(token)
        {
            [self.loginDelegate didLoginWithFacebookWithToken:token fullName:fullName userID:userID];
        }
        else
        {
            [self giveAlertForError:error socialNetwork:@"Facebook"];
        }
    }];
}

//Method called when the Twitter login button is pressed.
- (void)loginWithTwitterPressed
{
    [[RZSocialLoginManager defaultManager] getListOfAccountsWithTypeIdentifier:ACAccountTypeIdentifierTwitter options:0 completionBlock:^(NSArray *accounts, NSError *error) {
        
        //If there is more than one Twitter account, present an action sheet for the user to choose the account they would like to sign in with.
        if(accounts.count > 1)
        {
            //Store the array of account objects to retrieve one later when the user selects one from the action sheet.
            self.twitterAccounts = accounts;
            
            //Setup the action sheet.
            UIActionSheet *accountsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            for(ACAccount *account in accounts)
            {
                [accountsActionSheet addButtonWithTitle:[account username]];
            }
            
            //Add a "Cancel" button to the action sheet.
            [accountsActionSheet addButtonWithTitle:@"Cancel"];
            accountsActionSheet.cancelButtonIndex = accounts.count;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [accountsActionSheet showInView:self.view];
            });
        }
        else if(accounts.count == 1) //If there is only one account, login with it.
        {
            [self loginToTwitterWithAccount:[accounts lastObject]];
        }
        else //If there are no accounts, present an error to the user.
        {
            [self giveAlertForError:error socialNetwork:@"Twitter"];
        }
    }];
}

//Method called to login to a specific Twitter account.
- (void)loginToTwitterWithAccount:(ACAccount *)account
{
    [[RZSocialLoginManager defaultManager] loginToTwitterWithConsumerKey:self.twitterConsumerKey consumerSecret:self.twitterConsumerSecret account:account completion:^(NSString *token, NSString *tokenSecret, NSString *username, NSString *userID, NSError *error) {
        
        if((token && token.length > 0) && (tokenSecret && tokenSecret.length > 0))
        {
            [self.loginDelegate didLoginWithTwitterWithToken:token tokenSecret:tokenSecret username:username userID:userID];
        }
        else
        {
            [self giveAlertForError:error socialNetwork:@"Twitter"];
        }
    }];
}

#pragma mark - Email Login/Signup Methods

//Method called when the Email login button is pressed.
- (void)loginWithEmailPressed
{
    if(self.emailLoginController != nil)
    {
        self.emailLoginController.signUpController = self.signUpController;
        [self presentViewController:self.emailLoginController animated:YES completion:nil];
    }
}

//Method called when the Email signup button is pressed.
- (void)signupWithEmailPressed
{
    if(self.signUpController != nil)
    {
        [self presentViewController:self.signUpController animated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

//Called when the user selects a Twitter account to sign in with from an action sheet.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex)
    {
        [self loginToTwitterWithAccount:[self.twitterAccounts objectAtIndex:buttonIndex]];
    }
}

@end
