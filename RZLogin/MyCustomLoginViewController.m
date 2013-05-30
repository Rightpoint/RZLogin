//
//  MyCustomLoginViewController.m
//  RZLogin
//
//  Created by Daniel Kopyc on 5/20/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "MyCustomLoginViewController.h"

@interface MyCustomLoginViewController ()

@end

@implementation MyCustomLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // any custom initialization here
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Animate the background-image
    [UIView animateWithDuration:6.0f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x - 100,
                                                                     self.backgroundImageView.frame.origin.y - 50,
                                                                     self.backgroundImageView.frame.size.width * 2,
                                                                     self.backgroundImageView.frame.size.height * 2);
                     }
                     completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // dispose of any resources that can be recreated
}

@end
