//
//  XSTSAuthManager.m
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/8/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import "XSTSAuthManager.h"
#import "LiveAuthManager.h"
#import "AppDelegate.h"

XSTSAuthManager* sInstance = NULL;

static const NSString* UTOKEN_ENDPOINT = @"https://user.auth.xboxlive.com/user/authenticate";
static const NSString* XTOKEN_ENDPOINT = @"https://xsts.auth.xboxlive.com/xsts/authorize";

@implementation XSTSAuthManager

@synthesize mGamertag = mGamertag;
@synthesize mXUID = mXUID;

+(void)init
{
    sInstance = [[XSTSAuthManager alloc] InternalInit];
}

+(XSTSAuthManager*)GetInstance
{
    return sInstance;
}

-(instancetype)InternalInit
{
    return self;
}

-(void)GetXTokenForSandbox:(NSString*)inSandbox
{
    NSURL* queryURL = [NSURL URLWithString:(NSString*)UTOKEN_ENDPOINT];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:queryURL];
    
    [request setValue:@"0" forHTTPHeaderField:@"x-xbl-contract-version"];
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:  @"http://auth.xboxlive.com", @"RelyingParty",
                                                                            @"JWT", @"TokenType",
                                                                            NULL];
    
    NSDictionary* properties = [NSDictionary dictionaryWithObjectsAndKeys:  @"RPS", @"AuthMethod",
                                                                            @"user.auth.xboxlive.com", @"SiteName",
                                                                            [NSString stringWithFormat:@"d=%@", [LiveAuthManager GetInstance].mMSAToken], @"RpsTicket",
                                                                            NULL ];
    
    [dictionary setObject:properties forKey:@"Properties"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GetAppDelegate() AddText:@"Calling XASU..."];
    });
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
              completionHandler:^(NSData *data,
                                  NSURLResponse *response,
                                  NSError *error) {
                  
        NSDictionary* xasuResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        mUToken = [xasuResponse objectForKey:@"Token"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [GetAppDelegate() AddText:[NSString stringWithFormat:@"Got UToken, expires %@", [xasuResponse objectForKey:@"NotAfter"]]];
        });
        
        NSURL* queryURL = [NSURL URLWithString:(NSString*)XTOKEN_ENDPOINT];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:queryURL];
    
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:  @"http://xboxlive.com", @"RelyingParty",
                                                                                @"JWT", @"TokenType",
                                                                                NULL];
        
        NSDictionary* properties = [NSDictionary dictionaryWithObjectsAndKeys:  [NSArray arrayWithObjects:mUToken, NULL], @"UserTokens",
                                                                                inSandbox, @"SandboxId",
                                                                                NULL ];
        
        [dictionary setObject:properties forKey:@"Properties"];
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:NULL];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"POST"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                  completionHandler:^(NSData *data,
                                      NSURLResponse *response,
                                      NSError *error) {
            
            NSDictionary* xstsResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            mXToken = [xstsResponse objectForKey:@"Token"];
            
            NSDictionary* displayClaims = [xstsResponse objectForKey:@"DisplayClaims"];
            NSArray* xui = [displayClaims objectForKey:@"xui"];
            mGamertag = [xui[0] objectForKey:@"gtg"];
            mXUID = [xui[0] objectForKey:@"xid"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [GetAppDelegate() AddText:@"Got XToken"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"User logged in" object:NULL];
            });

        }] resume];
        
    }] resume];
}

@end