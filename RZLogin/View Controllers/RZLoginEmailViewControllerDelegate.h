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

@property (copy, readonly) ValidationBlock loginPasswordValidator;

- (void)loginPressedWithFormInformation:(NSDictionary *)formInfo;

@optional

// if sign-up is allowed... impl the following method too in your delegate
- (void)signUpPressedWithFormInformation:(NSDictionary *)formInfo;

@end
