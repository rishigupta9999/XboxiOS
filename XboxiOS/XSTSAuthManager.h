//
//  XSTSAuthManager.h
//  XboxiOS
//
//  Created by Rishi Gupta on 10/8/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSTSAuthManager : NSObject
{
    NSString* mUToken;
}

@property NSString* mGamertag;
@property NSString* mXUID;
@property NSString* mUserHash;
@property NSString* mXToken;
@property BOOL mLoggedIn;

+(void)init;
+(XSTSAuthManager*)GetInstance;

-(instancetype)InternalInit;

-(void)GetXTokenForSandbox:(NSString*)inSandbox;

@end