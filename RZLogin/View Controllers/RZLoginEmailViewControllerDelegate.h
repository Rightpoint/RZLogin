//
//  RZLoginEmailViewControllerDelegate.h
//  RZLogin
//
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZValidationInfo.h"
#import <Foundation/Foundation.h>

// RZLogin: to add support for login via email (with optional sign-up form),
// simply implement the following protocol in the 'delegate' for RZLoginViewController
//
@protocol RZLoginEmailViewControllerDelegate <NSObject>

- (void)loginPressedWithFormInformation:(NSDictionary *)formInfo;       // auth the entered email-address/password here in your delegate

@optional

// optional validators for email-address and password fields on login form
@property (nonatomic, readonly, strong) RZValidationInfo *loginEmailAddressFieldValidator;  // defaults to 'is a valid email address'
@property (nonatomic, readonly, strong) RZValidationInfo *loginPasswordFieldValidator;      // defaults to 'is non-empty'

// optional validators for email-address and password fields on sign-up form
@property (nonatomic, readonly, strong) RZValidationInfo *signUpEmailAddressFieldValidator; // defaults to 'is a valid email address'
@property (nonatomic, readonly, strong) RZValidationInfo *signUpPasswordFieldValidator;     // defaults to 'is non-empty'

- (void)signUpPressedWithFormInformation:(NSDictionary *)formInfo;      // if sign-up is allowed, also impl this method in your delegate

@end
