//
//  RZForgotPasswordViewController.h
//  RZLogin
//
//  Created by Mordechai Rynderman on 6/3/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZFormViewController.h"
#import "RZForgotPasswordViewConrollerDelegate.h"

@class RZLoginEmailViewController;

@interface RZForgotPasswordViewController : RZFormViewController

// a (weak) reference to the RZLoginEmailViewController that's presenting us on nav-stack
@property (nonatomic, weak) RZLoginEmailViewController *loginEmailViewController;

// the delegate
@property (nonatomic, weak) id<RZForgotPasswordViewConrollerDelegate> delegate;

@end
