//
//  RZSignUpViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZFormViewController.h"
#import "RZLoginEmailViewControllerDelegate.h"

@interface RZSignUpViewController : RZFormViewController

// this button is optional (only for modal presentation)
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

// a (weak) reference to the RZLoginViewController that's presenting us (either modally or via an RZEmailLoginViewController)
@property (nonatomic, weak) RZLoginViewController *loginViewController;

@property (nonatomic, weak) id<RZLoginEmailViewControllerDelegate> delegate;

- (IBAction)signupButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@end
