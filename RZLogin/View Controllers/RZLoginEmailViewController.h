//
//  RZLoginEmailViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZFormViewController.h"
#import "RZSignUpViewController.h"

//This protocol is implemented by the class which will handle logins.
@protocol RZLoginEmailViewControllerDelegate

//This method will be called when the login form is submitted with valid information.
- (void)loginPressedWithFormInformation:(NSDictionary *)formInfo;

@end

@interface RZLoginEmailViewController : RZFormViewController

@property (nonatomic, strong) IBOutlet UIButton *signUpButton;

//Reference to the sign up controller we may present.
@property (nonatomic, weak) RZSignUpViewController *signUpController;

@property (nonatomic, weak) id<RZLoginEmailViewControllerDelegate, RZSignUpViewControllerDelegate> loginDelegate;

- (IBAction)loginPressed;
- (IBAction)cancelPressed;
- (IBAction)signUpPressed;

@end
