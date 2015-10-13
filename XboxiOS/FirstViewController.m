//
//  FirstViewController.m
//  XboxiOS
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import "FirstViewController.h"
#import "LiveAuthManager.h"
#import <UIKit/UIView.h>
#import "AppDelegate.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UIWebView* mWebView;
@property (weak, nonatomic) IBOutlet UITextView *mTextView;
@property (weak, nonatomic) IBOutlet UITextField *mSandbox;

@end


@implementation FirstViewController

@synthesize mWebView = mWebView;
@synthesize mTextView = mTextView;
@synthesize mSandbox = mSandbox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mWebView.hidden = TRUE;
    mWebView.delegate = self;
    
    mTextView.editable = FALSE;
    
    GetAppDelegate().textView = mTextView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginButton:(id)sender {
    mWebView.hidden = FALSE;
    
    [[LiveAuthManager GetInstance] SignInWithWebView:mWebView sandbox:mSandbox.text];
    
    [mWebView setAlpha:0];

    [UIView animateWithDuration:0.5f animations:^{

        [mWebView setAlpha:1.0f];

    }];

}

- (IBAction)ClearCachedLoginButton:(id)sender
{

    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) 
    {
       [storage deleteCookie:cookie];
    }

    [GetAppDelegate() AddText:@"Cookies Cleared"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    BOOL complete = [[LiveAuthManager GetInstance] CheckLoadCompleted:webView];
    
    if (complete)
    {
        [UIView animateWithDuration:0.5f animations:^{
            [mWebView setAlpha:0.0f];
        } completion:^(BOOL inFinished){
            mWebView.hidden = TRUE;
            mWebView.delegate = NULL;
        }];
    }
}

@end
