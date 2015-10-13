//
//  XboxLiveCall.h
//  XboxiOS
//
//  Created by Rishi Gupta on 10/9/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XboxLiveCall : NSObject
{
    NSMutableURLRequest* mRequest;
}

@property NSString* _Nonnull mMethod;
@property NSData* _Nonnull mBody;

-(instancetype)initWithURL:(NSString* _Nonnull)inURL;
-(void)IssueAsync:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

@end
