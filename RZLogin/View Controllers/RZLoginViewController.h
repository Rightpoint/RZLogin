//
//  RZLoginViewController.h
//  RZLogin
//
//  RZLoginViewController is a UIViewController that encapsulates functionality for a "user login" experience, and allows them
//  to choose between several supported login 'types' (e.g. login with an email-address/password; login with Facebook or Twitter, etc.)
//
//  This class can be sub-classed to override defaults or implement custom functionality;
//  the use of alternate NIB/XIB files also allows for complete customization of all of the login views.
//  Please also refer to the examples in this project for details.
//
//  The delegate, which (depending on which login-types your app wishes to support),
//  must conform to one or more of the following protocols:
//
//      RZLoginEmailViewControllerDelegate -- for login with an email-address and password,
//      RZFacebookViewControllerDelegate   -- for login via Facebook account,
//      RZTwitterViewControllerDelegate    -- for login via Twitter account.
//
//  In the simplest use case, one can simply create a (default) instance of RZLoginViewController,
//  and push it onto the current nav-stack, for example like so:
//
//  @implementation MyRootViewController
//     ...
//
//  - (void) doLogin {
//
//      RZLoginViewController *loginController = [[RZLoginViewController alloc] init];
//      loginController.delegate = self;
//
//      [self.navigationController pushViewController:loginController animated:YES];
//  }
//
//  The delegate (typically 'self') can then simply implement the various properties and methods
//  required by each of the login-type protocols that it chooses to  support. For example, to support
//  login via Facebook, we would implement the protocol for RZLoginFacebookViewControllerDelegate, like so:
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
//    - (void)didLoginWithFacebookWithToken:(NSString *)fbToken fullName:(NSString *)fullName userId:(NSString *)userId
//    {
//        NSLog(@"%s: %@ - %@", __FUNCTION__, fullName, fbToken);
//    }
//
//  @end
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

// properties for various login options; note some apply to only certain login-types
@property (nonatomic, assign, getter=isSignupAllowed) BOOL signupAllowed;
@property (nonatomic, assign, getter=isForgotPasswordAllowed) BOOL forgotPasswordAllowed;
@property (nonatomic, assign, getter=shouldPresentViewsAsModal) BOOL presentViewsAsModal; // else, present via 'push' onto nav-controller

// the delegate (see above for details) must conform to one or more of the following protocols:
//  RZLoginEmailViewControllerDelegate, RZFacebookViewControllerDelegate, RZTwitterViewControllerDelegate
@property (nonatomic, weak) id delegate; 

@property (nonatomic, strong) RZLoginEmailViewController *emailLoginViewController;
@property (nonatomic, strong) RZSignUpViewController *signUpViewController;

@end
