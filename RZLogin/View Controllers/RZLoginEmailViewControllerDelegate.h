//
//  RZLoginEmailViewControllerDelegate.h
//  RZLogin
//
//  To support login with email-address/password, implement the following protocol in the 'delegate' for RZLoginViewController.
//
//  Created by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZValidator.h"
#import <Foundation/Foundation.h>

@class RZLoginViewController;

@protocol RZLoginEmailViewControllerDelegate <NSObject>

@required

// this method is called when an email-address/password is submitted; authenticate the formInfo in your delegate
- (void)loginViewController:(RZLoginViewController *)lvc loginButtonClickedWithFormInfo:(NSDictionary *)formInfo;

@optional

// properties for login-options for 'sign-up' form
@property (nonatomic, assign, getter=isSignupAllowed) BOOL signupAllowed;
@property (nonatomic, assign, getter=shouldPresentSignupFormAsModal) BOOL presentSignUpFormAsModal;

// this method is called when an email-address / password is submitted for 'sign-up'
// if sign-up is allowed (see above property), you must also implement this method in your delegate
- (void)loginViewController:(RZLoginViewController *)lvc signUpButtonClickedWithFormInfo:(NSDictionary *)formInfo;

// return true if you'd like to support 'forgot password' functionality (default is 'false' if unimplemented)
@property (nonatomic, assign, getter=isForgotPasswordAllowed) BOOL forgotPasswordAllowed;

// return true if email-login form should be presented modally (default is 'false' if unimplemented)
@property (nonatomic, assign, getter=shouldPresentAsModal) BOOL presentAsModal;

// optional validators for email-address and password fields on login form
@property (nonatomic, readonly, strong) RZValidator *loginEmailAddressFieldValidator;  // default validator: 'is a valid email address'
@property (nonatomic, readonly, strong) RZValidator *loginPasswordFieldValidator;      // default validator: 'is non-empty'

// optional validators for email-address and password fields on sign-up form
@property (nonatomic, readonly, strong) RZValidator *signUpEmailAddressFieldValidator; // default validator: 'is a valid email address'
@property (nonatomic, readonly, strong) RZValidator *signUpPasswordFieldValidator;     // default validator: 'is non-empty'


@end
