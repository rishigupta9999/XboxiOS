//
//  SecondViewController.m
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import "SecondViewController.h"
#import "XSTSAuthManager.h"

@interface SecondViewController ()


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mGamertag.text = [XSTSAuthManager GetInstance].mGamertag;
    self.mXUID.text = [XSTSAuthManager GetInstance].mXUID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
