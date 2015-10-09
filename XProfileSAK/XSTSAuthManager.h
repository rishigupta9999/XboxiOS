//
//  XSTSAuthManager.h
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/8/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSTSAuthManager : NSObject
{
    NSString* mUToken;
    NSString* mXToken;
}

+(void)init;
+(XSTSAuthManager*)GetInstance;

-(instancetype)InternalInit;

-(void)GetXTokenForSandbox:(NSString*)inSandbox;

@end