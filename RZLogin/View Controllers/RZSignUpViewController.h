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

@property (nonatomic, strong) IBOutlet UIButton *cancelButton; // this button is optional (only for modal presentation)

@property (nonatomic, weak) id<RZLoginEmailViewControllerDelegate> loginDelegate;

- (IBAction)signupButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@end
