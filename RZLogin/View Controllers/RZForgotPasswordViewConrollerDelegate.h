//
//  RZForgotPasswordViewConrollerDelegate.h
//  RZLogin
//
//  Created by Mordechai Rynderman on 6/5/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

@class RZLoginEmailViewController;
@class RZValidator;

@protocol RZForgotPasswordViewConrollerDelegate <NSObject>

@required

// this method is called when an email-address/password is submitted; authenticate the formInfo in your delegate
- (void)loginEmailViewController:(RZLoginEmailViewController *)lvc forgotPasswordEnteredWithFormInfo:(NSDictionary *)formInfo;

@property (nonatomic, readonly, strong) RZValidator *forgotPasswordEmailAddressFieldValidator; 

@end