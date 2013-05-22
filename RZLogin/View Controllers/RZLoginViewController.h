//
//  RZLoginViewController.h
//  RZLogin
//
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

// the delegate, which (depending on which login-types your app wishes to support),
// must conform to one or more of the following protocols:
// 
//      RZLoginEmailViewControllerDelegate -- for login with an email-address and password,
//      RZFacebookViewControllerDelegate   -- for login via Facebook account,
//      RZTwitterViewControllerDelegate    -- for login via Twitter account.
//
@property (nonatomic, weak) id delegate; 

@property (nonatomic, strong) RZLoginEmailViewController *emailLoginViewController;
@property (nonatomic, strong) RZSignUpViewController *signUpViewController;

@end
