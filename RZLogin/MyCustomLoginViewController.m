//
//  MyCustomLoginViewController.m
//  RZLogin
//
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

- (void)viewDidAppear:(BOOL)animated {

    // animate the background-image
    // (i.e. as an 'example' of a customization in our login view-controller ;)    
    [UIView animateWithDuration:6.0f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x,
                                                                     self.backgroundImageView.frame.origin.y,
                                                                     self.backgroundImageView.frame.size.width * 2,
                                                                     self.backgroundImageView.frame.size.height * 2);
                     }
                     completion:^(BOOL finished){
                         // nothing to do here
                     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // dispose of any resources that can be recreated
}

@end
