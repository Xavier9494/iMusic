//
//  PlayListViewController.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/4.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

typedef NSInteger(^numberOfPlayList)(void);
typedef id (^modelOfIndexPath)(NSIndexPath * indexPath);

@interface PlayListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *playList;

-(void)setNumberOfPlayList:(NSInteger(^)(void))numberOfPlayList;

-(void)setModelOfIndexPath:(id (^)(NSIndexPath * indexPath))modelOfIndexPath;

-(void)refresh;



@end
