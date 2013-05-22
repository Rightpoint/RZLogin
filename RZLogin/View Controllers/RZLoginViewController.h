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

// outlets to all of the different login/sign-up buttons (note: all are optional)
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

@property (nonatomic, weak) id delegate; // this delegate *may* conform to one or more of the RZLoginXXXViewControllerDelegate protocols

@property (nonatomic, strong) RZLoginEmailViewController *emailLoginViewController;
@property (nonatomic, strong) RZSignUpViewController *signUpViewController;

@end
