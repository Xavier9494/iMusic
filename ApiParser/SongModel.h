//
//  SongModel.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/2.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "JSONModel.h"

@interface SongModel : JSONModel<NSCoding>
@property(nonatomic,copy) NSString<Optional> * title;
@property(nonatomic,copy) NSString<Optional> * artist_id;
@property(nonatomic,copy) NSString<Optional> * author;
@property(nonatomic,copy) NSString<Optional> * all_rate;
@property(nonatomic,copy) NSString<Optional> * lrclink;
@property(nonatomic,copy) NSString<Optional> * song_id;
@property(nonatomic,copy) NSString<Optional> * pic_small;
@property(nonatomic,copy) NSString<Optional> * pic_big;
@property(nonatomic,copy) NSString<Optional> * language;
@property(nonatomic,copy) NSString<Optional> * country;
@property(nonatomic,copy) NSString<Optional> * style;

@property(nonatomic,copy) NSString<Optional> * filePath;
@property(nonatomic,copy) NSString<Optional> * rate;
@property(nonatomic,strong) NSNumber<Optional> * fileSize;
@property(nonatomic,strong) NSData<Optional> * data_pic_small;
@property(nonatomic,strong) NSData<Optional> * data_pic_big;
@property(nonatomic,strong) NSString<Optional> * lyric;
@end
