//
//  GoogleAuthView.h
//  Rue La La
//
//  Created by Alex Wang on 5/20/13.
//  Copyright (c) 2013 Raizlabs Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoogleAuthDelegate <NSObject>

-(void) googleTokenReceived:(NSString*) token;
-(void) googleCancelButtonPressed;

@end

@interface GoogleAuthView : UIWebView

@property (weak, nonatomic) id<GoogleAuthDelegate> googleDelegate;

- (id)initWithGoogleClientId:(NSString *)anyClientId delegate:(id<GoogleAuthDelegate>)delegate;
- (void)loadInitialRequest;

@end