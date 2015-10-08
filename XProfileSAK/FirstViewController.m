//
//  FirstViewController.m
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import "FirstViewController.h"



@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UIWebView* mWebView;

@end


@implementation FirstViewController

@synthesize mWebView = mWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mWebView.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginButton:(id)sender {
    NSLog(@"Foo");
}

@end
