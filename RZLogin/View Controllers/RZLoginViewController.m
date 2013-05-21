//
//  RZLoginViewController.m
//  RZLogin
//
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginViewController.h"
#import "RZSocialLoginManager.h"
#import <Accounts/Accounts.h>

@interface RZLoginViewController () <UIActionSheetDelegate>

// stores the list of Twitter accounts on the device for use with the account selection action sheet
@property (nonatomic, strong) NSArray *twitterAccounts;

@property (nonatomic, strong) NSString *facebookAppId; // note fetched from delegate (if it impls the proper protocol)
@property (nonatomic, strong) NSString *twitterConsumerKey;
@property (nonatomic, strong) NSString *twitterConsumerSecret;

@end


@implementation RZLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // any further init goes here...
        
        // set defaults for login-options
        self.signupAllowed = YES;
        self.forgotPasswordAllowed = NO;
        self.presentViewsAsModal = NO;
    }
    return self;
}


#pragma mark -
#pragma mark - login type properties

//
// note these properties are readonly: based on which protocol(s) our delegate chooses to implement
//

- (BOOL)supportsLoginTypeEmail {
    
    return( [((NSObject *)self.delegate) conformsToProtocol:@protocol(RZLoginEmailViewControllerDelegate)] );
}

- (BOOL)supportsLoginTypeFacebook {
    
    return( [((NSObject *)self.delegate) conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)] );
}

- (BOOL)supportsLoginTypeTwitter {

    return( [((NSObject *)self.delegate) conformsToProtocol:@protocol(RZLoginTwitterViewControllerDelegate)] );
}


#pragma mark -
#pragma mark - UIViewController methods

- (void)configureView {
    
    // configure view appropriately, depending on which login-types we support...
    //
    if( ![self supportsLoginTypeFacebook] ) {
        // client doesn't want facebook login support, so remove its button...
        [self.facebookLoginButton removeFromSuperview];
        
    }
    if( ![self supportsLoginTypeTwitter] ) {
        // client doesn't want twitter login support, so remove its button...
        [self.twitterLoginButton removeFromSuperview];
    }
    if( ![self supportsLoginTypeEmail] ) {
        // client doesn't want email login support, so remove its button(s)...
        [self.emailLoginButton removeFromSuperview];
        [self.emailSignUpButton removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    if( [self supportsLoginTypeEmail] ) {
        //
        // init email/sign-up view-controllers if we're supporting login via email...
        //
        if( self.emailLoginViewController == nil ) {
            // if no custom v/c has already been specified, allocate the 'default' login-with-email v/c
            self.emailLoginViewController = [[RZLoginEmailViewController alloc] initWithNibName:@"RZLoginEmailViewController" bundle:nil];
        }
        self.emailLoginViewController.loginDelegate = self.delegate; // in any case, use the same delegate
        
        // we will validate the email login fields using placeholder text keys
        [self.emailLoginViewController setFormKeyType:RZFormFieldKeyTypePlaceholderText];
        
        // validate email using standard email-validator
        [self.emailLoginViewController addFormValidationInfo:[RZValidationInfo emailValidationInfo] forPlaceholderText:@"Email"];
        
        // validate password with a block
        ValidationBlock passwordValidator = ((id<RZLoginEmailViewControllerDelegate>)self.delegate).loginPasswordValidator;
        [self.emailLoginViewController addFormValidationInfo:[RZValidationInfo validationInfoWithBlock:passwordValidator] forPlaceholderText:@"Password"];

        if( self.isSignupAllowed ) {
            self.signUpViewController = [[RZSignUpViewController alloc] initWithNibName:@"RZSignUpViewController" bundle:nil];
            self.signUpViewController.loginDelegate = self.delegate;

        } else {
            self.signUpViewController = nil;
        }
        self.emailLoginViewController.signUpController = self.signUpViewController;
        
        if( ![self supportsLoginTypeFacebook] && ![self supportsLoginTypeTwitter] ) {
            // if we're ONLY supporting login via email...
            // immediately present the email login v/c (i.e. skip our own view with facebook/twitter/email buttons)
            [self addChildViewController:self.emailLoginViewController];
            [self.view addSubview:self.emailLoginViewController.view];
        }
    }
}


#pragma mark -
#pragma mark - login info properties

// note we defer to the delegate's impl for each of these properties,
// depending on which login-type protocol(s) it chooses to implement.

- (NSString *)facebookAppId {
    
    if( [((NSObject *)self.delegate) conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)]) {
        return ((NSObject<RZLoginFacebookViewControllerDelegate> *) self.delegate).facebookAppId;
    } else {
        return nil;
    }
}

- (NSString *)twitterConsumerKey {
    
    if( [((NSObject *)self.delegate) conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)]) {
        return ((NSObject<RZLoginTwitterViewControllerDelegate> *) self.delegate).twitterConsumerKey;
    } else {
        return nil;
    }
}

- (NSString *)twitterConsumerSecret {
    
    if( [((NSObject *)self.delegate) conformsToProtocol:@protocol(RZLoginFacebookViewControllerDelegate)]) {
        return ((NSObject<RZLoginTwitterViewControllerDelegate> *) self.delegate).twitterConsumerSecret;
    } else {
        return nil;
    }
}


#pragma mark -
#pragma mark - error alert

- (void)showAlertForError:(NSError *)error socialNetwork:(NSString *)socialNetworkName
{
    // this method is called from completion blocks that may not be on the main thread,
    // so note we dispatch the UIAlertView to the main thread here
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.code == 6 || error.code == 7 || error == nil)
        {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                        message:[NSString stringWithFormat:@"Make sure you have logged in and given permission to this app to access your %@ account in the Settings app.", socialNetworkName]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                        message:[NSString stringWithFormat:@"There was a problem loggin in with %@.", socialNetworkName]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    });
}


#pragma mark -
#pragma mark - button actions

// login with Email button action
- (IBAction)loginWithEmailAction:(id)sender {

    if( self.presentViewsAsModal ) {
        [self presentViewController:self.emailLoginViewController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:self.emailLoginViewController animated:YES];
    }
}

// signup with email button action
- (IBAction)signupWithEmailAction:(id)sender {

    if( self.presentViewsAsModal ) {
        [self presentViewController:self.signUpViewController animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:self.signUpViewController animated:YES];
    }
}

// login with Facebook button action
- (IBAction)loginWithFacebookAction:(id)sender {
    
    [[RZSocialLoginManager defaultManager] loginToFacebookWithAppID:self.facebookAppId
                                                         completion:^(NSString *token, NSString *fullName, NSString *userId, NSError *error) {
        if(token)
        {
            [((NSObject<RZLoginFacebookViewControllerDelegate> *) self.delegate) didLoginWithFacebookWithToken:token
                                                                                                      fullName:fullName
                                                                                                        userId:userId];
            
        } else {       
            [self showAlertForError:error socialNetwork:@"Facebook"];
        }
    }];
}

// login with Twitter button action
- (IBAction)loginWithTwitterAction:(id)sender {
    
    [[RZSocialLoginManager defaultManager] getListOfAccountsWithTypeIdentifier:ACAccountTypeIdentifierTwitter options:0 completionBlock:^(NSArray *accounts, NSError *error) {
        
        // if there is more than one Twitter account, present an action sheet
        // for the user to choose the account they would like to sign in with
        if(accounts.count > 1)
        {
            // store the array of account objects to retrieve one later when the user selects one from the action sheet
            self.twitterAccounts = accounts;
            
            // setup the action sheet
            UIActionSheet *accountsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Twitter Account"
                                                                             delegate:self
                                                                    cancelButtonTitle:nil
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:nil];
            for(ACAccount *account in accounts)
            {
                [accountsActionSheet addButtonWithTitle:[account username]];
            }
            
            // add a "Cancel" button to the action sheet.
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

// login to a specific Twitter account
- (void)loginToTwitterWithAccount:(ACAccount *)account {

    [[RZSocialLoginManager defaultManager] loginToTwitterWithConsumerKey:self.twitterConsumerKey
                                                          consumerSecret:self.twitterConsumerSecret
                                                                 account:account
        completion:^(NSString *token, NSString *tokenSecret, NSString *username, NSString *userId, NSError *error) {
            
            if((token && token.length > 0) && (tokenSecret && tokenSecret.length > 0)) {

                [((NSObject<RZLoginTwitterViewControllerDelegate> *) self.delegate) didLoginWithTwitterWithToken:token
                                                                                                      tokenSecret:tokenSecret
                                                                                                         username:username
                                                                                                           userId:userId];
            } else {
                [self showAlertForError:error socialNetwork:@"Twitter"];
            }
    }];
}


#pragma -
#pragma mark - UIActionSheetDelegate

// called when the user selects a Twitter account to sign-in with from the action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex)
    {
        [self loginToTwitterWithAccount:[self.twitterAccounts objectAtIndex:buttonIndex]];
    }
}


@end
