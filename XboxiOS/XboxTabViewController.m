//
//  XboxTabViewController.m
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/9/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import "XboxTabViewController.h"
#import "AppDelegate.h"
#import "SecondViewController.h"
#import "XSTSAuthManager.h"

@implementation XboxTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GetAppDelegate().tabBarController = self;
}

@end
