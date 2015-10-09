//
//  LiveAuthManager.m
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveAuthManager.h"
#import <UIKit/UIWebView.h>
#import "AppDelegate.h"
#import "XSTSAuthManager.h"

const NSString* CLIENT_ID = @"0000000044165E79";
const NSString* CLIENT_SECRET = @"kCJGy2k0RnR31CHZJU7K0srszoA4hNnK";

// This string has the formatting token ("%@") substituted at runtime.  Since this string is passed to stringWithFormat, we have to escape anything that would be interpreted as a formatting token.  Hence %20 becomes %%20.
const NSString* OAUTH_SIGNIN_URL = @"https://login.live.com/oauth20_authorize.srf?client_id=%@&scope=Xboxlive.signin%%20Xboxlive.offline_access&response_type=code&redirect_uri=https://login.live.com/oauth20_desktop.srf";



const NSString* REDIRECT_URI = @"https://login.live.com/oauth20_desktop.srf";

const NSString* OAUTH_SIGNOUT_URL = @"https://login.live.com/oauth20_logout.srf";
const NSString* OAUTH_GETTOKEN_URL = @"https://login.live.com/oauth20_token.srf";
      NSString* OAUTH_GETTOKEN_CONTENT = @"client_id=%@&redirect_uri=https://login.live.com/oauth20_desktop.srf&client_secret=%@&grant_type=authorization_code";
      NSString* OAUTH_GETREFRESHTOKEN_CONTENT = @"client_id=%@&redirect_uri=https://login.live.com/oauth20_desktop.srf&client_secret=%@&grant_type=refresh_token";
const NSString* OAUTH_SIGNOUT_PAGE = @"oauth20_logout.srf";
const NSString* OAUTH_SIGNIN_COMPLETION_PAGE = @"oauth20_desktop.srf";

@implementation LiveAuthManager

static LiveAuthManager* sInstance = NULL;

@synthesize mLoginState = mLoginState;
@synthesize mMSAToken = mMSAToken;
@synthesize mSandbox = mSandbox;

+(void)init
{
    sInstance = [[LiveAuthManager alloc] InternalInit];
}

+(LiveAuthManager*)GetInstance
{
    return sInstance;
}

-(instancetype)InternalInit
{
    mRefreshToken = 0;
    mTokenExpiryTime = 0;
    mMSAToken = [[NSString alloc] init];
    mTokenValid = FALSE;
    mLastError = [[NSString alloc] init];

    mLoginState = ELoginStateNone;
    
    return self;
}

-(void)SignInWithWebView:(UIWebView*)inWebView sandbox:(NSString*)inSandbox
{
    NSString* signInURL = [NSString stringWithString:(NSString*)OAUTH_SIGNIN_URL];
    signInURL = [NSString stringWithFormat:(NSString*)signInURL, CLIENT_ID];
    
    NSURL* nsUrl = [NSURL URLWithString:signInURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [inWebView loadRequest:request];
    
    mSandbox = inSandbox;
}

-(BOOL)CheckLoadCompleted:(UIWebView*)inWebView
{
    NSURL* url = inWebView.request.mainDocumentURL;
    
    NSArray* pathComponents = [url pathComponents];
    
    NSString* authCode = NULL;
    
    [GetAppDelegate() AddText:[NSString stringWithFormat:@"%@ loaded", url]];
    
    for (NSString* curString in pathComponents)
    {
        if ([curString caseInsensitiveCompare:(NSString*)OAUTH_SIGNIN_COMPLETION_PAGE] == NSOrderedSame)
        {
            mLoginState = ELoginStateSignedIn;
            
            NSString* query = url.query;
            NSArray* args = [query componentsSeparatedByString:@"&"];
            
            for (NSString* curArg in args)
            {
                NSArray* pair = [curArg componentsSeparatedByString:@"="];
                
                if ([pair[0] caseInsensitiveCompare:@"code"] == NSOrderedSame)
                {
                    authCode = pair[1];
                }
            }
            
            break;
        }
    }
    
    if (authCode != NULL)
    {
        [self GetTokensFromLive:authCode];
        mLoginState = ELoginStateSignedIn;

        return TRUE;
    }
    
    return FALSE;
}

-(void)GetTokensFromLive:(NSString*)inAuthCode
{
    mTokenValid = FALSE;
    mMSAToken = @"";
    mRefreshToken = @"";
    
    NSURLComponents* components = [NSURLComponents componentsWithString:(NSString*)OAUTH_GETTOKEN_URL];
    
    NSURLQueryItem* clientId = [NSURLQueryItem queryItemWithName:@"client_id" value:(NSString*)CLIENT_ID];
    NSURLQueryItem* code = [NSURLQueryItem queryItemWithName:@"code" value:inAuthCode];
    NSURLQueryItem* redirectURI = [NSURLQueryItem queryItemWithName:@"redirect_uri" value:(NSString*)REDIRECT_URI];
    NSURLQueryItem* clientSecret = [NSURLQueryItem queryItemWithName:@"client_secret" value:(NSString*)CLIENT_SECRET];
    NSURLQueryItem* grantType = [NSURLQueryItem queryItemWithName:@"grant_type" value:@"authorization_code"];
    
    components.queryItems = @[clientId, redirectURI, code, clientSecret, grantType];
    
    NSURL* queryURL = components.URL;

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:queryURL];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
              completionHandler:^(NSData *data,
                                  NSURLResponse *response,
                                  NSError *error) {
                  
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        mMSAToken = [dictionary objectForKey:@"access_token"];
        
        NSString* expiryDuration = [dictionary objectForKey:@"expires_in"];
        mTokenExpiryTime = [NSDate dateWithTimeIntervalSinceNow:[expiryDuration floatValue]];

        mTokenValid = TRUE;
        
        [[XSTSAuthManager GetInstance] GetXTokenForSandbox:mSandbox];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [GetAppDelegate() AddText:[NSString stringWithFormat:@"Got RPS ticket %@", mMSAToken]];
            [GetAppDelegate() AddText:[NSString stringWithFormat:@"Expires in %@", expiryDuration]];
        });

      }] resume];
}

@end