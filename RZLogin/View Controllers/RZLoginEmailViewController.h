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
#import "RZLoginEmailViewControllerDelegate.h"

@interface RZLoginEmailViewController : RZFormViewController

@property (nonatomic, strong) IBOutlet UIButton *signUpButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton; // this button is optional (only for modal presentation)

// reference to the sign-up form view-controller that we (optionally) present when 'sign-up' button is clicked
@property (nonatomic, weak) RZSignUpViewController *signUpController;

// whether or not we should present the sign-up form modally
@property (nonatomic, assign, getter=shouldPresentSignupFormAsModal) BOOL presentSignUpFormAsModal;

@property (nonatomic, weak) id<RZLoginEmailViewControllerDelegate> loginDelegate;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)signupButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@end
