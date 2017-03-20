//
//  SongListModel.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/2.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "JSONModel.h"
#import "SongModel.h"

@interface SongListModel : NSObject
@property(nonatomic,copy) NSString * pic;
@property(nonatomic,copy) NSString * listName;
@property(nonatomic,assign) NSInteger listId;
@property(nonatomic,strong) NSArray<SongModel *> * top3;
@end
