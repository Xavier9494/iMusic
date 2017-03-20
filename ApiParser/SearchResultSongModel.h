//
//  SearchResultSongModel.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/3.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "JSONModel.h"

@interface SearchResultSongModel : JSONModel
@property(nonatomic,copy) NSString<Optional> * songid;
@property(nonatomic,copy) NSString<Optional> * songname;
@property(nonatomic,copy) NSString<Optional> * artistname;
@end
