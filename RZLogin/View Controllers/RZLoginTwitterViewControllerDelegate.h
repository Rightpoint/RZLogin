//
//  RZLoginTwitterViewControllerDelegate.h
//  RZLogin
//
//  For Twitter login support, implement the following protocol in the 'delegate' for RZLoginViewController.
//
//  Created by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZLoginTwitterViewControllerDelegate <NSObject>

@property (nonatomic, readonly, strong) NSString *twitterConsumerKey;
@property (nonatomic, readonly, strong) NSString *twitterConsumerSecret;

// this method is called when login via Twitter succeeds
- (void)loginViewController:(RZLoginViewController *)lvc didLoginWithTwitterWithToken:(NSString *)twitterToken
                                                                          tokenSecret:(NSString *)tokenSecret
                                                                             username:(NSString *)username
                                                                               userId:(NSString *)userId;

@end
