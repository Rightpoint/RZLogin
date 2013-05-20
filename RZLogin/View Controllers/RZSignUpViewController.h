//
//  RZSignUpViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZFormViewController.h"

//This protocol is implemented by the class which will handle sign ups.
@protocol RZSignUpViewControllerDelegate

//This method will be called when the signup form is submitted with valid information.
- (void)signUpPressedWithFormInformation:(NSDictionary *)formInfo;

@end

@interface RZSignUpViewController : RZFormViewController

@property (nonatomic, weak) id<RZSignUpViewControllerDelegate> loginDelegate;

- (IBAction)signUpPressed;
- (IBAction)cancelPressed;

@end
