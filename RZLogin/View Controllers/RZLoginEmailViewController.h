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

// reference to the sign-up controller we may present if 'sign-up' is clicked
@property (nonatomic, weak) RZSignUpViewController *signUpController;

@property (nonatomic, weak) id<RZLoginEmailViewControllerDelegate> loginDelegate;

- (IBAction)loginPressed;
- (IBAction)cancelPressed;
- (IBAction)signUpPressed;

@end
