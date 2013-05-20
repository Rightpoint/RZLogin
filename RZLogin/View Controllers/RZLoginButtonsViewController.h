//
//  RZLoginButtonsViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZLoginEmailViewController.h"
#import "RZSignUpViewController.h"

//Bitmask to specify which types of login fields will be supported.
typedef enum {
    RZLoginTypeFacebook     = 1 << 0,
    RZLoginTypeTwitter      = 1 << 1,
    RZLoginTypeEmail        = 1 << 2,
    RZLoginOptionNoSignup   = 1 << 3, // FIXME: shouldn't login 'options' be separate from 'type'?
} RZLoginType;

typedef int RZLoginTypes;

//This protocol is implemented by the class which will handle logins.
@protocol RZLoginButtonsViewControllerDelegate

- (void)didLoginWithFacebookWithToken:(NSString *)fbToken fullName:(NSString *)fullName userID:(NSString *)userID;
- (void)didLoginWithTwitterWithToken:(NSString *)twitterToken tokenSecret:(NSString *)tokenSecret username:(NSString *)username userID:(NSString *)userID;

@end

@interface RZLoginButtonsViewController : UIViewController

//Outlets to all of the different login/sign up buttons.
@property (nonatomic, strong) IBOutlet UIButton *fbLoginButton;
@property (nonatomic, strong) IBOutlet UIButton *twitterLoginButton;
@property (nonatomic, strong) IBOutlet UIButton *emailSignUpButton;
@property (nonatomic, strong) IBOutlet UIButton *emailLoginButton;

//Store references to the email login and signup controllers we are using.
@property (nonatomic, weak) RZLoginEmailViewController *emailLoginController;
@property (nonatomic, weak) RZSignUpViewController *signUpController;

//Properties to store the available login types and appropriate social media app keys.
@property (nonatomic, assign) RZLoginTypes loginTypes;
@property (nonatomic, strong) NSString *facebokAppID;
@property (nonatomic, strong) NSString *twitterConsumerKey;
@property (nonatomic, strong) NSString *twitterConsumerSecret;

//Delegate to provide information about login events.
@property (nonatomic, weak) id<RZLoginButtonsViewControllerDelegate, RZLoginEmailViewControllerDelegate, RZSignUpViewControllerDelegate> loginDelegate;

@end