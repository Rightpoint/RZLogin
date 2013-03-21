//
//  RZLoginViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//
//  This class can be subclassed for extra functionality. Three nib files are provided for customization of views. If the nibs
//  do not provide for enough functionality, set the File's Owner to your subclass and make sure to hook up outlets to the following:
//
//  In RZLoginEmailViewController:
//      Outlets: Outlet collection to all of the text fields. Text fields should have unique placeholder text or unique tags.
//      Actions: loginPressed, cancelPressed, signUpPressed
//
//  In RZSignUpViewController:
//      Outlets: Outlet collection to all of the text fields. Text fields should have unique placeholder text or unique tags.
//      Actions: signUpPressed, cancelPressed
//
//  In RZLoginButtonsViewController (actions will be automatically assigned to each of these buttons):
//      Outlets: fbLoginButton, twitterLoginButton, emailSignUpButton, emailLoginButton
//
//  The loginDelegate must implement RZLoginEmailViewControllerDelegate, RZLoginButtonsViewControllerDelegate, and RZSignUpViewControllerDelegate.

#import <UIKit/UIKit.h>
#import "RZLoginButtonsViewController.h"
#import "RZLoginEmailViewController.h"
#import "RZSignUpViewController.h"

@interface RZLoginViewController : UIViewController

//Delegate to provide information about login events.
@property (nonatomic, weak) id<RZLoginButtonsViewControllerDelegate, RZLoginEmailViewControllerDelegate, RZSignUpViewControllerDelegate> loginDelegate;

//Reference to the email login controller we are using.
@property (nonatomic, strong) RZLoginEmailViewController *emailLoginController;

//Reference to the sign up login controller we are using.
@property (nonatomic, strong) RZSignUpViewController *signUpController;

//Initializer with the following parameters:
//  anyLoginTypes: Bitwise selection of which login types should be supported (i.e. RZLoginTypeFacebook | RZLoginTypeTwitter).
//  fbAppID: Facebook application ID if Facebook login is supported, otherwise nil.
//  twConsumer: Twitter application consumer key if Twitter login is supported, otherwise nil.
//  twSecret: Twitter application consumer secret if Twitter login is supported, otherwise nil.
- (id)initWithLoginTypes:(RZLoginTypes)anyLoginTypes facebookAppID:(NSString *)fbAppID twitterConsumerKey:(NSString *)twConsumer twitterConsumerSecret:(NSString *)twSecret loginDelegate:(id<RZLoginButtonsViewControllerDelegate, RZLoginEmailViewControllerDelegate>)anyLoginDelegate;

@end
