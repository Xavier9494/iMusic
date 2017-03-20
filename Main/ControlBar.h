//
//  ControlBar.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/28.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlBar : UIView
@property (weak, nonatomic) IBOutlet UIImageView *singerImageView;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
