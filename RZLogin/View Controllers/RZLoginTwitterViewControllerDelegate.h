//
//  RZLoginTwitterViewControllerDelegate.h
//  RZLogin
//
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

// RZLogin: to add support for login via Twitter,
// simply implement the following protocol in the 'delegate' for RZLoginViewController
//
@protocol RZLoginTwitterViewControllerDelegate <NSObject>

@property (nonatomic, readonly, strong) NSString *twitterConsumerKey;
@property (nonatomic, readonly, strong) NSString *twitterConsumerSecret;

- (void)didLoginWithTwitterWithToken:(NSString *)twitterToken
                         tokenSecret:(NSString *)tokenSecret
                            username:(NSString *)username
                              userId:(NSString *)userId;

@end
