//
//  MyDownLoadTableViewCell.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/8.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDownLoadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *songInfo;
@property (weak, nonatomic) IBOutlet UILabel *downInfo;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *downState;

@end
