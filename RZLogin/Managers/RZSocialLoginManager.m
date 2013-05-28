//
//  RZSocialLoginManager.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/19/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZSocialLoginManager.h"
#import "TWAPIManager.h"
#import "TWSignedRequest.h"
#import <Accounts/Accounts.h>

#define kRZFBPermissionPublishToFeed                @"publish_actions"

#define kTwitterReverseAuthResponseTokenIndex       0
#define kTwitterReverseAuthResponseTokenSecretIndex 1
#define kTwitterReverseAuthResponseUserIDIndex      2
#define kTwitterReverseAuthResponseUsernameIndex    3

@interface RZSocialLoginManager ()

@property (nonatomic, strong) ACAccountStore *accountStore;

- (NSString *)extractValueFromTwitterResponseLine:(NSString *)responseLine;

@end

@implementation RZSocialLoginManager

//Default login web service manager.
+ (RZSocialLoginManager *)defaultManager
{
    static RZSocialLoginManager* _defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[RZSocialLoginManager alloc] init];
    });
    return _defaultManager;
}

//Default Facebook login method that only asks for the user's email
- (void)loginToFacebookWithAppID:(NSString *)facebookAppID completion:(FacebookLoginCompletionBlock)completionBlock
{
    [self loginToFacebookWithAppID:facebookAppID
                   withPermissions:[NSArray arrayWithObject:@"email"]
                          audience:nil
                        completion:completionBlock];
}

//Method to login via Facebook and retrieve an oAuth token. 
- (void)loginToFacebookWithAppID:(NSString *)facebookAppID withPermissions:(NSArray *)permissions audience:(NSString *)audience completion:(FacebookLoginCompletionBlock)completionBlock
{
    //Dictionary of Facebook requestion options that includes the facebook app ID as well as the permissions we would like access to.
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:facebookAppID, ACFacebookAppIdKey, permissions, ACFacebookPermissionsKey, nil];
    
    if([permissions containsObject:kRZFBPermissionPublishToFeed])
    {
        if(audience != nil)
        {
            [options setObject:audience forKey:ACFacebookAudienceKey];
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"You must provide an audience to loginToFacebookWithAppId when requesting permission to publish to a feed."];
        }
    }
    
    [self getListOfAccountsWithTypeIdentifier:ACAccountTypeIdentifierFacebook options:options completionBlock:^(NSArray *accounts, NSError *error) {
        
        //Retrieve the oAuth token.
        NSString *oauthToken = nil;
        id account = [accounts lastObject];
        id credential = [account credential]; //Why is the credential property "inacessible" in the documentation?
        oauthToken = [credential oauthToken];
        
        //Get the user's full name and Facebook user id also.
        id accountProperties = [account valueForKey:@"properties"];
        NSString *fullName = [accountProperties valueForKey:@"fullname"];
        NSString *userID = [accountProperties valueForKey:@"uid"];
        
        //Pass back the oAuth token if it exists.
        if (oauthToken && completionBlock)
        {
            completionBlock(oauthToken, fullName, userID, nil);
        }
        else if(completionBlock)
        {
            completionBlock(nil, nil, nil, error);
        }
    }];
}

//Method to login via Twitter and retrieve an oAuth token.
- (void)loginToTwitterWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret account:(ACAccount *)account completion:(TwitterLoginCompletionBlock)completionBlock
{
    //Perform a reverse authentication for the Twitter account in order to retrieve the oAuth token. We need to do this because ACAccount objects
    //do not store oAuth tokens for Twitter accounts.
    [[TWAPIManager defaultManager] performReverseAuthForAccount:account consumerKey:consumerKey consumerSecret:consumerSecret withHandler:^(NSData *responseData, NSError *error) {
        
        //Extract the oAuth token, token secret, username, and user id from the response. The response is of the format:
        //oauth_token=XXXX&oauth_token_secret=XXXX&user_id=XXXX&screen_name=XXXX
        NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
        
        if(parts.count >= 4) //If we have the right number of response parts, extract the values.
        {
            NSString *token = [self extractValueFromTwitterResponseLine:[parts objectAtIndex:kTwitterReverseAuthResponseTokenIndex]];
            NSString *tokenSecret = [self extractValueFromTwitterResponseLine:[parts objectAtIndex:kTwitterReverseAuthResponseTokenSecretIndex]];
            NSString *userID = [self extractValueFromTwitterResponseLine:[parts objectAtIndex:kTwitterReverseAuthResponseUserIDIndex]];
            NSString *username = [self extractValueFromTwitterResponseLine:[parts objectAtIndex:kTwitterReverseAuthResponseUsernameIndex]];
            
            if(!(token && tokenSecret) && completionBlock)
            {
                completionBlock(nil, nil, nil, nil, nil);
            }
            else if(completionBlock)
            {
                completionBlock(token, tokenSecret, username, userID, nil);
            }
        }
        else //If there are not the right number of response parts, do not pass back any data.
        {
            completionBlock(nil, nil, nil, nil, nil);
        }
    }];
}

//Method to retrieve all of the accounts of a given type from the account store.
- (void)getListOfAccountsWithTypeIdentifier:(NSString *)accountTypeIdentifier options:(NSDictionary *)options completionBlock:(AccountsRequestCompletionBlock)completionBlock
{
    //Lazy load the account store.
    if(!self.accountStore)
    {
        self.accountStore = [[ACAccountStore alloc] init];
    }
    
    //Get the account type we're looking for.
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:accountTypeIdentifier];
    
    //Request access to the list of accounts with the given type.
    [self.accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        
        //If we have been granted access, get the list of accounts and pass them back in the completion block.
        if (granted)
        {
            NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
            if(completionBlock)
            {
                completionBlock(accounts, nil);
            }
        }
        else if(completionBlock) //If we have not been granted access, pass back nil for the accounts array and any error that occurred.
        {
            completionBlock(nil, error);
        }
    }];
}

#pragma mark - String helpers

//Extract the value of a string with the format "key=value". This is used to extract values from Twitter's reverse auth response data.
- (NSString *)extractValueFromTwitterResponseLine:(NSString *)responseLine
{
    NSString *value = [responseLine copy];
    NSRange valueStart = [value rangeOfString:@"="];
    
    //If "=" is not found or is the last character, there is no value in this key-value pair.
    if(valueStart.location == value.length - 1 || valueStart.location == NSNotFound)
    {
        value = nil;
    }
    else
    {
        value = [value substringFromIndex:valueStart.location + 1];
    }
    
    return value;
}

@end
