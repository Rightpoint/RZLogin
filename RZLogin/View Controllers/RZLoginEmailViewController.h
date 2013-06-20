//
//  RZLoginEmailViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZFormViewController.h"
#import "RZSignUpViewController.h"
#import "RZLoginEmailViewControllerDelegate.h"
#import "RZForgotPasswordViewController.h"

@interface RZLoginEmailViewController : RZFormViewController

@property (nonatomic, strong) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton; // this button is optional (only for modal presentation)
@property (nonatomic, strong) IBOutlet UIButton *forgotPasswordButton; // Optional button

// a (weak) reference to the RZLoginViewController that's presenting us (either modally or on nav-stack)
@property (nonatomic, weak) RZLoginViewController *loginViewController;

// whether or not we should present the email-login form modally (as specified by delegate)
@property (nonatomic, readonly, getter=shouldPresentAsModal) BOOL presentAsModal;

// whether or not we should allow sign-up (as specified by delegate)
@property (nonatomic, readonly, getter=isSignupAllowed) BOOL signupAllowed;

// whether or not we should allow a forgot password option
@property (nonatomic, readonly, getter=isForgotPasswordAllowed) BOOL forgotPasswordAllowed;

// whether or not we should present the sign-up form modally (as specified by delegate)
@property (nonatomic, readonly, getter=shouldPresentSignupFormAsModal) BOOL presentSignUpFormAsModal;

// the sign-up form view-controller that we (optionally) present when 'sign-up' button is clicked
// (note if not explicitly set, and isSignupAllow is true, uses default instance of a simple RZSignUpViewController)
@property (nonatomic, strong) RZSignUpViewController *signUpViewController;

@property (nonatomic, strong) RZForgotPasswordViewController *forgotPasswordViewController;

// the delegate
@property (nonatomic, weak) id<RZLoginEmailViewControllerDelegate> delegate;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)signupButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)forgotPasswordButtonAction:(id)sender;

@end