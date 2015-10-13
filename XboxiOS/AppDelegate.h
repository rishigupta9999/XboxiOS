//
//  AppDelegate.h
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XboxTabViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString* mTextViewString;
    UIView* mTextView;
}

-(void)AddText:(NSString*)inText;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITextView* textView;
@property (strong, nonatomic) XboxTabViewController* tabBarController;

@end

