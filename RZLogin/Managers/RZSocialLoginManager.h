//
//  RZSocialLoginManager.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/19/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//
//  This class is used to handle the requests to Facebook (via the builtin account store) and Twitter to retrieve oAuth tokens.

#import <Foundation/Foundation.h>

//Completion block to pass back a Facebook oAuth token.
typedef void (^FacebookLoginCompletionBlock)(NSString *token, NSString *fullName, NSString *userID, NSError *error);

//Completion block to pass back a Twitter oAuth token and token secret.
typedef void (^TwitterLoginCompletionBlock)(NSString *token, NSString *tokenSecret, NSString *username, NSString *userID, NSError *error);

//Completion block to pass back an array of ACAccounts.
typedef void (^AccountsRequestCompletionBlock)(NSArray *accounts, NSError *error);

@class ACAccountType;
@class ACAccount;

@interface RZSocialLoginManager : NSObject

//Return the shared default web manager.
+ (RZSocialLoginManager *)defaultManager;

//Method to retrieve a Facebook oAuth token. Parameters:
//  facebookAppID: The Facebook application ID.
- (void)loginToFacebookWithAppID:(NSString *)facebookAppID completion:(FacebookLoginCompletionBlock)completionBlock;

//Method to retrieve a Twitter oAuth token. Parameters:
//  consumerKey: The Twitter application consumer key.
//  consumerSecret: The twitter application consumer secret.
//  account: The ACAccount object corresponding to the Twitter account to login with.
- (void)loginToTwitterWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret account:(ACAccount *)account completion:(TwitterLoginCompletionBlock)completionBlock;

//Method to retrieve all of the accounts of a given type. Parameters:
//  accountTypeIdentifier: i.e. ACAccountTypeIdentifierFacebook or ACAccountTypeIdentifierTwitter
//  options: Options dictionary to pass to the account store when requesting access to an account. For example, to access a Facebook
//           account, you pass the Facebook app ID as well as an array of requested permissions.
- (void)getListOfAccountsWithTypeIdentifier:(NSString *)accountTypeIdentifier options:(NSDictionary *)options completionBlock:(AccountsRequestCompletionBlock)completionBlock;

@end
