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
}

+(void)init;
+(XSTSAuthManager*)GetInstance;

-(instancetype)InternalInit;

-(void)GetXToken;

@end