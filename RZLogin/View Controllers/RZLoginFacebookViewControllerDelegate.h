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

@required

// this method is called when login via Facebook succeeds
- (void)loginViewController:(RZLoginViewController *)lvc didLoginWithFacebookWithToken:(NSString *)fbToken
                                                                              fullName:(NSString *)fullName
                                                                                userId:(NSString *)userId;

@optional

// this method is called when login via Facebook is about to begin
// use it to display a loading HUD or do any other prep for login
- (void)loginViewControllerWillBeginFacebookLogin:(RZLoginViewController*)lvc;

// this method is called with login via Facebook fails
- (void)loginViewController:(RZLoginViewController *)lvc facebookLoginFailedWithError:(NSError*)error;

@end
