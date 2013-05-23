//
//  RZLoginFacebookViewControllerDelegate.h
//  RZLogin
//
//  Created by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

// RZLogin: to add support for login via Facebook,
// simply implement the following protocol in the 'delegate' for RZLoginViewController
//
@protocol RZLoginFacebookViewControllerDelegate <NSObject>

@property (nonatomic, readonly, strong) NSString *facebookAppId;

- (void)didLoginWithFacebookWithToken:(NSString *)fbToken
                             fullName:(NSString *)fullName
                               userId:(NSString *)userId;

@end
