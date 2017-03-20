//
//  SongTableViewCell.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/5.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UIImageView *moreButton;
@property (weak, nonatomic) IBOutlet UIView *OperationView;
@property (weak, nonatomic) IBOutlet UILabel *isAlreadyDown;
@end
