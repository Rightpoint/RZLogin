//
//  RZLoginFacebookViewControllerDelegate.h
//  RZLogin
//
//  For Facebook login support, implement the following protocol in the 'delegate' for RZLoginViewController.
//
//  Created by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZLoginFacebookViewControllerDelegate <NSObject>

@property (nonatomic, readonly, strong) NSString *facebookAppId;

// this method is called when login via Facebook succeeds
- (void)loginViewController:(RZLoginViewController *)lvc didLoginWithFacebookWithToken:(NSString *)fbToken
                                                                              fullName:(NSString *)fullName
                                                                                userId:(NSString *)userId;

@end
