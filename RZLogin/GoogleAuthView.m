//
//  GoogleAuthView.m
//  Rue La La
//
//  Created by Alex Wang on 5/20/13.
//  Copyright (c) 2013 Raizlabs Corporation. All rights reserved.
//

#import "GoogleAuthView.h"
#import <objc/runtime.h>

@interface OAuthWebViewDelegate : NSObject<UIWebViewDelegate>

@property (weak, nonatomic) id<GoogleAuthDelegate> googleDelegate;

- (id)initWithRetrievalDelegate:(id<GoogleAuthDelegate>)delegate;

@end

@implementation OAuthWebViewDelegate

- (id)initWithRetrievalDelegate:(id<GoogleAuthDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.googleDelegate = delegate;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSString* codeField = @"code=";
    NSString* webViewUrl = theWebView.request.URL.absoluteString;
    NSRange range = [webViewUrl rangeOfString:codeField];
    if (range.location != NSNotFound)
    {
        NSString* token = [webViewUrl substringFromIndex:(NSMaxRange(range))];
        NSString* endField = @"&";
        NSRange tokenRange = [token rangeOfString:endField];
        
        if (tokenRange.location != NSNotFound)
        {
            token = [token substringToIndex:(NSMaxRange(range))];
        }
        
        [self.googleDelegate googleTokenReceived:token];
    }
    else
    {
        NSString* errorField = @"error=";
        NSRange range = [webViewUrl rangeOfString:errorField];
        if (range.location != NSNotFound)
        {
            [self.googleDelegate googleCancelButtonPressed];
        }
    }
}

@end

@interface GoogleAuthView ()

@property (nonatomic, strong) NSString *clientId;

@end

@implementation GoogleAuthView

- (id)initWithFrame:(CGRect)frame withDelegate:(id<GoogleAuthDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.googleDelegate = delegate;
    }
    return self;
}

- (id)initWithGoogleClientId:(NSString *)anyClientId delegate:(id<GoogleAuthDelegate>)delegate
{
    if(self = [super init])
    {
        self.clientId = anyClientId;
        self.googleDelegate = delegate;
    }
    
    return self;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.googleDelegate googleCancelButtonPressed];
}

- (void)setGoogleDelegate:(id<GoogleAuthDelegate>)googleDelegate
{
    // Initialization code
    _googleDelegate = googleDelegate;
    OAuthWebViewDelegate *tokenDelegate = [[OAuthWebViewDelegate alloc] initWithRetrievalDelegate:self.googleDelegate];
    self.delegate = tokenDelegate;
    
    // Set associated object to retain it. Will be released when the webview deallocs, since delegate is weak reference.
    objc_setAssociatedObject(self, "OAuthWebViewDelegate", tokenDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (void)loadInitialRequest
{
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=1058632622299-0f3d9e0kirm3457e8458an1ah5rp0p90.apps.googleusercontent.com&scope=https://www.googleapis.com/auth/plus.login&state=gplusregister&approval_prompt=auto&redirect_uri=http://localhost"]]];
}

@end
