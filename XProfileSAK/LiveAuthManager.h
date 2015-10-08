//
//  LiveAuthManager.h
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

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
    NSString*   mMSAToken;
    BOOL        mTokenValid;
    NSString*   mLastError;
}

@property ELoginState mLoginState;

+(void)init;
+(LiveAuthManager*)GetInstance;

-(instancetype)InternalInit;

@end