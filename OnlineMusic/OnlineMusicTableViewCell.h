//
//  OnlineMusicTableViewCell.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/2.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineMusicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstSong;
@property (weak, nonatomic) IBOutlet UILabel *secondSong;
@property (weak, nonatomic) IBOutlet UILabel *thirdSong;

@end
