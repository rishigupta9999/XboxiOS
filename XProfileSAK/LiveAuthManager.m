//
//  LiveAuthManager.m
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveAuthManager.h"

@implementation LiveAuthManager

const NSString* CLIENT_ID = @"000000004812FA70";
const NSString* CLIENT_SECRET = @"WY9o8+UrYvaDhNf0Zj2J5tOLo6KRU/Cg";
      NSString* OAUTH_SIGNIN_URL = @"https://login.live.com/oauth20_authorize.srf?client_id=%@&scope=Xboxlive.signin%20Xboxlive.offline_access&response_type=code&redirect_uri=https://login.live.com/oauth20_desktop.srf";
const NSString* OAUTH_SIGNOUT_URL = @"https://login.live.com/oauth20_logout.srf";
const NSString* OAUTH_GETTOKEN_URL = @"https://login.live.com/oauth20_token.srf";
      NSString* OAUTH_GETTOKEN_CONTENT = @"client_id=%@&redirect_uri=https://login.live.com/oauth20_desktop.srf&client_secret=%@&grant_type=authorization_code";
      NSString* OAUTH_GETREFRESHTOKEN_CONTENT = @"client_id=%@&redirect_uri=https://login.live.com/oauth20_desktop.srf&client_secret=%@&grant_type=refresh_token";
const NSString* OAUTH_SIGNOUT_PAGE = @"oauth20_logout.srf";
const NSString* OAUTH_SIGNIN_COMPLETION_PAGE = @"oauth20_desktop.srf";


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
    
    mLoginState = ELoginStateNone;
    
    return self;
}

@end