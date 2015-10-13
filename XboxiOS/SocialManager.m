//
//  SocialManager.m
//  XboxiOS
//
//  Created by Rishi Gupta on 10/9/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import "SocialManager.h"
#import "XSTSAuthManager.h"
#import "XboxLiveCall.h"

static SocialManager* sInstance = NULL;
static const NSString* PROFILE_URL = @"https://profile.xboxlive.com/users/batch/profile/settings";

@implementation SocialManager

+(void)init
{
    sInstance = [[SocialManager alloc] InternalInit];
}

-(instancetype)InternalInit
{
    [ [NSNotificationCenter defaultCenter]
      addObserver:self selector:@selector(EventReceived:) name:NULL object:NULL ];

    return self;
}

-(void)EventReceived:(NSNotification*)inNotification
{
    if ([[inNotification name] caseInsensitiveCompare:@"User Logged In"] == NSOrderedSame)
    {
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        NSArray* array = [NSArray arrayWithObjects:[XSTSAuthManager GetInstance].mXUID, NULL];
        [dictionary setObject:array forKey:@"userIDs"];
        
        NSArray* settingsArray = [NSArray arrayWithObjects:@"GameDisplayName", @"GameDisplayPicRaw", @"Gamerscore", @"Gamertag", @"AccountTier", NULL];
        [dictionary setObject:settingsArray forKey:@"settings"];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

        
        XboxLiveCall* call = [[XboxLiveCall alloc] initWithURL:(NSString*)PROFILE_URL];
        call.mBody = jsonData;
        call.mMethod = @"POST";
        
        [call IssueAsync:^(NSData *data,
                                      NSURLResponse *response,
                                      NSError *error) {
                NSDictionary *jsonString = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSLog(@"%@", jsonString);
            }];
    }
}

@end
