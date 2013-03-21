//
//  RZLoginViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/18/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZLoginViewController.h"
#import "RZSignUpViewController.h"

@interface RZLoginViewController ()

@property (nonatomic, strong) RZLoginButtonsViewController *buttonsLoginController;

@end

@implementation RZLoginViewController

//Initializer.
- (id)initWithLoginTypes:(RZLoginTypes)anyLoginTypes facebookAppID:(NSString *)fbAppID twitterConsumerKey:(NSString *)twConsumer twitterConsumerSecret:(NSString *)twSecret loginDelegate:(id<RZLoginButtonsViewControllerDelegate, RZLoginEmailViewControllerDelegate, RZSignUpViewControllerDelegate>)anyLoginDelegate
{
    if(self = [super init])
    {
        //Set the login delegate.
        self.loginDelegate = anyLoginDelegate;
        
        if(anyLoginTypes & RZLoginTypeEmail)
        {
            self.emailLoginController = [[RZLoginEmailViewController alloc] initWithNibName:@"RZLoginEmailViewController" bundle:nil];
            self.signUpController = [[RZSignUpViewController alloc] initWithNibName:@"RZSignUpViewController" bundle:nil];
            
            self.emailLoginController.loginDelegate = self.loginDelegate;
            self.signUpController.loginDelegate = self.loginDelegate;
        }
        
        //Check if we are using any social media logins. If so, display the login buttons controller.
        if(anyLoginTypes & RZLoginTypeFacebook || anyLoginTypes & RZLoginTypeTwitter)
        {
            self.buttonsLoginController = [[RZLoginButtonsViewController alloc] initWithNibName:@"RZLoginButtonsViewController" bundle:nil];
            
            //Set the loginDelegate to self, as this class will pass back all login event information
            //to the provided object implementing RZLoginViewControllerDelegate.
            self.buttonsLoginController.loginDelegate = self.loginDelegate;
            
            //Set the login types and any social media login keys.
            self.buttonsLoginController.loginTypes = anyLoginTypes;
            self.buttonsLoginController.facebokAppID = fbAppID;
            self.buttonsLoginController.twitterConsumerKey = twConsumer;
            self.buttonsLoginController.twitterConsumerSecret = twSecret;
            
            self.buttonsLoginController.emailLoginController = self.emailLoginController;
            self.buttonsLoginController.signUpController = self.signUpController;
            
            //Add the child view controller and set the view.
            [self addChildViewController:self.buttonsLoginController];
            [self.view addSubview:self.buttonsLoginController.view];
        }
        else if(anyLoginTypes & RZLoginTypeEmail) //If we are only supporting email, go straight to the email login controller.
        {
            [self addChildViewController:self.emailLoginController];
            [self.view addSubview:self.emailLoginController.view];
        }
        else //Case where no login types are specified.
        {
            [NSException raise:@"loginTypes invalid" format:@"Please set loginTypes before presenting the login controller."];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
