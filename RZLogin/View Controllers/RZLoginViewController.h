//
//  RZLoginViewController.h
//  RZLogin
//
//  RZLoginViewController is a UIViewController that encapsulates functionality for a "user login" experience, and allows them
//  to choose between several supported login 'types'; for example login with an email-address/password,
//  or login with Facebook or Twitter, etc.
//
//  This class can be sub-classed to override defaults or implement custom functionality;
//  note the use of alternate NIB/XIB files also allows for complete customization of all of the login views.
//  Please also refer to the examples in this project for details.
//
//  Depending on which login-types your app wishes to support, you must provide one or more delegates for each type,
//  and which conform, respectively, to protocols listed:
//
//      emailLoginDelgate     : for login w/ email-address and password; must implement the protocol RZLoginEmailViewControllerDelegate
//      facebookLoginDelegate : for login via Facebook account; must implement the protocol RZLoginFacebookViewControllerDelegate
//      twitterLoginDelegate  : for login via Twitter account; must implement the protocol RZLoginTwitterViewControllerDelegate
//
//  To illustrate the simplest use-case, we can create a (default) instance of RZLoginViewController,
//  and push it onto the current nav-stack; and handle login via Facebook, for example like so:
//
//  @implementation MyRootViewController
//     ...
//
//  - (void) doLogin {
//
//      RZLoginViewController *loginViewController = [[RZLoginViewController alloc] init];
//      loginViewController.facebookLoginDelegate = self;
//
//      [self.navigationController pushViewController:loginViewController animated:YES];
//  }
//
//  The delegate (typically 'self') then simply implements the various properties and methods required
//  by the login-type protocol(s) that support. For example, to support login via Facebook, we would simply
//  implement the protocol for RZLoginFacebookViewControllerDelegate, like so:
//
//  @interface MyRootViewController () <RZLoginFacebookViewControllerDelegate>
//     ...
//
//  @implementation MyRootViewController
//     ...
//
//    - (NSString *)facebookAppId {
//        
//        return @"351055245000574";
//    }
//
//    - (void)loginViewController:(RZLoginViewController *)lvc didLoginWithFacebookWithToken:(NSString *)fbToken
//                                                                                  fullName:(NSString *)fullName
//                                                                                    userId:(NSString *)userId
//    {
//        NSLog(@"%s: %@ - %@", __FUNCTION__, fullName, fbToken);
//    }
//
//  @end
//
//  Also note for certain login-types, there are various LOGIN OPTIONS properties, which default to typical values.
//  These values can be overridden via the delegate for a given login-type.
//
//  As part of RZLoginEmailViewControllerDelegate, the following options properties can be specified
//  for the email-login form, and it's (optional) sign-up form:
// 
//      signupAllowed                : if true, show the 'sign-up' button, both from main view as well as from the email-login form itself
//      presentSignUpFormAsModal     : if true (and if sign-up is allowed), present the sign-up form modally (the default behavior)
//      forgotPasswordAllowed        : if true, show a 'forgot password' button from the email-login form (default is: false)
//      presentEmailLoginFormAsModal : defaults to false; but if true, we present the email-login form modally
//                                     (note you must add a 'cancel' button to your custom form in this case; wired up to |cancelButtonAction|)
//
//  ---------------------------------------------------------------------------------
//  Further notes on the RZLoginEmailViewController and RZSignUpViewController forms:
//
//  In addition, note that if you're going to customize either the email login or sign-up forms,
//  you should be aware of the following points:
//
//  1. The |formFields| IBOutletCollection, which should include each of the UITextFields in the form
//     (i.e. the emailField, passwordField, and passwordField, as appropriate).
//  2. The action method for each button should also be wired-up when creating a custom XIB for these forms.
//  3. Each text-field should also have either a unique placeholder-text value or a unique view 'tag',
//     since these are used by the form-field validators (RZValidator).
//  4. The 'sign-up' form requires that the first password field has a 'tag' of '2'; and the second a tag of '3'
//     (used by the validator to ensure that the password is correctly entered twice by the user).
//  5. Note that the 'cancel' button is optional; it is required only if you intend to present either
//     form 'modally' -- see login-options |presentEmailLoginFormAsModal| and |presentSignUpFormAsModal|.
//
//  Created by Joshua Leibsly on 3/18/13. Contributions and refactor by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "RZLoginEmailViewController.h"
#import "RZSignUpViewController.h"

#import "RZLoginEmailViewControllerDelegate.h"
#import "RZLoginFacebookViewControllerDelegate.h"
#import "RZLoginTwitterViewControllerDelegate.h"

@interface RZLoginViewController : UIViewController

// outlets to login and sign-up buttons 
@property (nonatomic, strong) IBOutlet UIButton *facebookLoginButton;
@property (nonatomic, strong) IBOutlet UIButton *twitterLoginButton;
@property (nonatomic, strong) IBOutlet UIButton *emailSignUpButton;
@property (nonatomic, strong) IBOutlet UIButton *emailLoginButton;

// properties for login-types supported
@property (nonatomic, readonly) BOOL supportsLoginTypeEmail;
@property (nonatomic, readonly) BOOL supportsLoginTypeFacebook;
@property (nonatomic, readonly) BOOL supportsLoginTypeTwitter;

// delegates for each of the (optionally) supported login-types
@property (nonatomic, weak) id<RZLoginEmailViewControllerDelegate> emailLoginDelegate;
@property (nonatomic, weak) id<RZLoginFacebookViewControllerDelegate> facebookLoginDelegate;
@property (nonatomic, weak) id<RZLoginTwitterViewControllerDelegate> twitterLoginDelegate;

// set this property to specify a customized email-login form
@property (nonatomic, strong) RZLoginEmailViewController *emailLoginViewController;

@end
