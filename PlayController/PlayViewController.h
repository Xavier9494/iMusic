//
//  PlayViewController.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/28.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlBar.h"

typedef enum : NSUInteger {
    PlayModeOrder,
    PlayModeCycle,
    PlayModeRandom,
    PlayModeSingle
} PlayMode;

typedef enum : NSUInteger {
    playStateLoad,
    PlayStateStop,
    PlayStatePlaying,
    PlayStatePause
} PlayState;

@interface PlayViewController :UIViewController

+(PlayViewController *)sharedPlayViewController;

@property(nonatomic,strong) ControlBar * controlBar;
@property(nonatomic,strong) NSMutableArray * currentPlayList;
@property(nonatomic,assign) NSInteger currentPlaySong;
@property(nonatomic,assign) PlayMode mode;
@property(nonatomic,assign) PlayState state;
-(void)storePlayState;

-(void)switchPage:(NSInteger)page;

@end
