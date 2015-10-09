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

const NSString* CLIENT_ID = @"000000004812FA70";
const NSString* CLIENT_SECRET = @"WY9o8+UrYvaDhNf0Zj2J5tOLo6KRU/Cg";
const NSString* OAUTH_SIGNIN_URL = @"https://login.live.com/oauth20_authorize.srf?client_id=000000004812FA70&scope=Xboxlive.signin%20Xboxlive.offline_access&response_type=code&redirect_uri=https://login.live.com/oauth20_desktop.srf";

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

-(void)SignInWithWebView:(UIWebView*)inWebView
{
    NSURL* nsUrl = [NSURL URLWithString:(NSString*)OAUTH_SIGNIN_URL];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [inWebView loadRequest:request];
}

-(BOOL)CheckLoadCompleted:(UIWebView*)inWebView
{
    NSURL* url = inWebView.request.mainDocumentURL;
    
    NSArray* pathComponents = [url pathComponents];
    
    NSLog(@"URL = %@, Query = %@", url, url.query);
    
    NSString* authCode = NULL;
    
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
    NSLog(@"Query url %@", queryURL);

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
      }] resume];
}

@end