//
//  LiveAuthManager.h
//  XboxiOS
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIWebView;

typedef enum
{
    ELoginStateNone,
    ELoginStateSigningIn,
    ELoginStateSignedIn,
    ELoginStateRefreshingToken,
    ELoginStateSigningOut,
    ELoginStateSignedOut,
    ELoginStateError
} ELoginState;

@interface LiveAuthManager : NSObject
{
    NSString*   mRefreshToken;
    NSDate*     mTokenExpiryTime;
    BOOL        mTokenValid;
    NSString*   mLastError;
}

@property ELoginState mLoginState;
@property NSString* mMSAToken;
@property NSString* mSandbox;

+(void)init;
+(LiveAuthManager*)GetInstance;

-(instancetype)InternalInit;

-(void)SignInWithWebView:(UIWebView*)inWebView sandbox:(NSString*)inSandbox;
-(BOOL)CheckLoadCompleted:(UIWebView*)inWebView;
-(void)GetTokensFromLive:(NSString*)inAuthCode;

@end