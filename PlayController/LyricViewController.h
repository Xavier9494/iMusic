//
//  LyricViewController.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/4.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LyricViewController : UIViewController
@property(nonatomic,strong) NSString * lyric;

-(void)locationLyric:(CMTime)location;
-(void)resetLoaction;
@end
