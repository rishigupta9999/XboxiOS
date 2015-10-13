//
//  XboxLiveCall.m
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/9/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import "XboxLiveCall.h"
#import "XSTSAuthManager.h"

@implementation XboxLiveCall

-(instancetype)initWithURL:(NSString*)inURL
{
    self = [super init];
    
    mRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:inURL]];
    
    [mRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mRequest setValue:[NSString stringWithFormat:@"XBL3.0 x=%@;%@", [XSTSAuthManager GetInstance].mUserHash, [XSTSAuthManager GetInstance].mXToken]
                forHTTPHeaderField:@"Authorization"];
    [mRequest setValue:@"UTF-8" forHTTPHeaderField:@"Accept-Charset"];
    [mRequest setValue:@"2" forHTTPHeaderField:@"x-xbl-contract-version"];
    
    return self;
}

-(void)IssueAsync:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    [mRequest setHTTPBody:self.mBody];
    [mRequest setHTTPMethod:self.mMethod];
    
    [[session dataTaskWithRequest:mRequest completionHandler:completionHandler] resume];
}

@end
