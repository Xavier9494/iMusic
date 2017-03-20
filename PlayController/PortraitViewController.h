//
//  PortraitViewController.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/4.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayViewController;

@interface PortraitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *portrait;

-(void)timerStart;
-(void)timerStop;
@end
