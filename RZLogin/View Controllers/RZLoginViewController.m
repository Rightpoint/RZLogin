//
//  RZLoginViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13. Contributions and refactor by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginViewController.h"
#import "RZSocialLoginManager.h"
#import <Accounts/Accounts.h>

@interface RZLoginViewController () <UIActionSheetDelegate>

// A list of Twitter accounts on the device for use with the account selection action sheet
@property (nonatomic, strong) NSArray *twitterAccounts;

// Properties are all fetched from the delegate
@property (nonatomic, readonly, strong) NSString *facebookAppId;
@property (nonatomic, readonly, strong) NSString *twitterConsumerKey;
@property (nonatomic, readonly, strong) NSString *twitterConsumerSecret;

@end

@implementation RZLoginViewController

-(id) init
{
    return [self initWithNibName:@"RZLoginViewController" bundle:nil];
}

#pragma mark - login type properties

// These properties are readonly, since they're based on which protocol(s) our delegate chooses to implement
// i.e. for each 'type' of login the client-application wants to support
- (BOOL)supportsLoginTypeEmail
{
    return [self.emailLoginDelegate conformsToProtocol:@protocol(RZLoginEmailViewControllerDelegate)];
}

- (BOOL)supportsLoginTypeFacebook
{
    return [self.facebookLoginDelegate conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)];
}

- (BOOL)supportsLoginTypeTwitter
{
    return [self.twitterLoginDelegate conformsToProtocol:@protocol(RZLoginTwitterViewControllerDelegate)];
}


#pragma mark - login info properties

// Defer to the delegate's impl for each of these properties,
// depending on which login-type protocol(s) it chooses to implement.
- (NSString *)facebookAppId
{
    
    if( [self.facebookLoginDelegate conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)] ) {
        return ((id<RZLoginFacebookViewControllerDelegate>) self.facebookLoginDelegate).facebookAppId;
    } else {
        return nil;
    }
}

- (NSString *)twitterConsumerKey
{
    if( [self.twitterLoginDelegate conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)] ) {
        return ((id<RZLoginTwitterViewControllerDelegate>) self.twitterLoginDelegate).twitterConsumerKey;
    } else {
        return nil;
    }
}

- (NSString *)twitterConsumerSecret
{
    if( [self.twitterLoginDelegate conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)] ) {
        return ((id<RZLoginTwitterViewControllerDelegate>) self.twitterLoginDelegate).twitterConsumerSecret;
    } else {
        return nil;
    }
}

- (void)setEmailLoginViewController:(RZLoginEmailViewController *)emailLoginViewController
{
    _emailLoginViewController = emailLoginViewController;
    _emailLoginViewController.loginViewController = self;
}


#pragma mark - UIViewController methods

- (void)configureView
{
    // Configure view appropriately, depending on which login-types we support
    if( ![self supportsLoginTypeFacebook] ) {
        // Client doesn't want facebook login support, so remove its button
        [self.facebookLoginButton removeFromSuperview];
    }
    if( ![self supportsLoginTypeTwitter] ) {
        // Client doesn't want twitter login support, so remove its button
        [self.twitterLoginButton removeFromSuperview];
    }
    if (!self.emailLoginViewController.isSignupAllowed) {
        [self.emailSignUpButton removeFromSuperview];
    }
    if( ![self supportsLoginTypeEmail] ) {
        // Client doesn't want email login support, so remove its button(s)
        [self.emailLoginButton removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    if( [self supportsLoginTypeEmail] )
    {
        // If login is supported via email, init our email-login and sign-up view-controllers
        // Also connect any form field validators (specified by the delegate)
        if( self.emailLoginViewController == nil ) {
            // If no custom VC has already been specified, allocate the 'default' login-with-email VC
            self.emailLoginViewController = [[RZLoginEmailViewController alloc] initWithNibName:@"RZLoginEmailViewController" bundle:nil];
        }
        if( ![self supportsLoginTypeFacebook] && ![self supportsLoginTypeTwitter] ) {
            // If ONLY login via email is supported, immediately present the email login VC
            // (i.e. skip our own view with facebook/twitter/email buttons)
            [self addChildViewController:self.emailLoginViewController];
            [self.view addSubview:self.emailLoginViewController.view];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if( self.navigationController.viewControllers[0] == self )
    {
        // If we're at the bottom of the nav-stack, hide the nav-bar
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [super viewWillAppear:animated];
}

#pragma mark - error alert

- (void)showAlertForError:(NSError *)error socialNetwork:(NSString *)socialNetworkName
{
    // This method is called from completion blocks that may not be on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.code == 6 || error.code == 7 || error == nil)
        {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                        message:[NSString stringWithFormat:@"Make sure you have logged in and given permission to this app to access your %@ account in the Settings app.", socialNetworkName]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                        message:[NSString stringWithFormat:@"There was a problem loggin in with %@.", socialNetworkName]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    });
}

#pragma mark - button actions

- (IBAction)loginWithEmailAction:(id)sender
{
    if( self.emailLoginViewController.shouldPresentAsModal ) {
        [self presentViewController:self.emailLoginViewController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:self.emailLoginViewController animated:YES];
    }
}

- (IBAction)signupWithEmailAction:(id)sender
{
    if( self.emailLoginViewController.shouldPresentSignupFormAsModal ) {
        [self presentViewController:self.emailLoginViewController.signUpViewController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:self.emailLoginViewController.signUpViewController animated:YES];
    }
}

- (IBAction)loginWithFacebookAction:(id)sender
{
    [[RZSocialLoginManager defaultManager] loginToFacebookWithAppID:self.facebookAppId
                                                         completion:^(NSString *token, NSString *fullName, NSString *userId, NSError *error)
     {
         if(token) {
             [self.facebookLoginDelegate loginViewController:self didLoginWithFacebookWithToken:token fullName:fullName userId:userId];
         } else {
             [self showAlertForError:error socialNetwork:@"Facebook"];
         }
     }];
}

- (IBAction)loginWithTwitterAction:(id)sender
{
    [[RZSocialLoginManager defaultManager] getListOfAccountsWithTypeIdentifier:ACAccountTypeIdentifierTwitter
                                                                       options:0
                                                               completionBlock:^(NSArray *accounts, NSError *error)
     {
         // If there is more than one Twitter account, present an action sheet
         // for the user to choose the account they would like to sign in with
         if(accounts.count > 1)
         {
             // Store the array of account objects to retrieve one later when the user selects one from the action sheet
             self.twitterAccounts = accounts;
             
             // Setup the action sheet
             UIActionSheet *accountsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter Account"
                                                                              delegate:self
                                                                     cancelButtonTitle:nil
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:nil];
             for(ACAccount *account in accounts)
             {
                 [accountsActionSheet addButtonWithTitle:[account username]];
             }
             
             [accountsActionSheet addButtonWithTitle:@"Cancel"];
             accountsActionSheet.cancelButtonIndex = accounts.count;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [accountsActionSheet showInView:self.view];
             });
         }
         else if(accounts.count == 1) // if there is only one account, login with it
         {
             [self loginToTwitterWithAccount:[accounts lastObject]];
         }
         else // if there are no accounts, present an error to the user
         {
             [self showAlertForError:error socialNetwork:@"Twitter"];
         }
     }];
}

- (void)loginToTwitterWithAccount:(ACAccount *)account
{
    [[RZSocialLoginManager defaultManager] loginToTwitterWithConsumerKey:self.twitterConsumerKey
                                                          consumerSecret:self.twitterConsumerSecret
                                                                 account:account
        completion:^(NSString *token, NSString *tokenSecret, NSString *username, NSString *userId, NSError *error) {
                                                                  
                    if( (token && token.length > 0) && (tokenSecret && tokenSecret.length > 0) ) {
                        [self.twitterLoginDelegate loginViewController:self didLoginWithTwitterWithToken:token tokenSecret:tokenSecret username:username userId:userId];
                    } else {
                        [self showAlertForError:error socialNetwork:@"Twitter"];
                    }
    }];
}

#pragma mark - UIActionSheetDelegate

// Called when the user selects a Twitter account to sign-in with from the action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex) {
        [self loginToTwitterWithAccount:[self.twitterAccounts objectAtIndex:buttonIndex]];
    }
}

@end
