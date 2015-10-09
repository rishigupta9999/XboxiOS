//
//  SecondViewController.h
//  XProfileSAK
//
//  Created by Rishi Gupta on 10/7/15.
//  Copyright © 2015 Neon Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
{
    NSNotificationCenter* mCenter;
}

- (void)EventReceived:(NSNotification *)inNotification;

@property (weak, nonatomic) IBOutlet UILabel *mGamertag;
@property (weak, nonatomic) IBOutlet UILabel *mXUID;


@end

