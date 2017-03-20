//
//  SongModel.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/2.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "SongModel.h"

@implementation SongModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"song_id":@"songid"}];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.artist_id = [aDecoder decodeObjectForKey:@"artist_id"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.all_rate = [aDecoder decodeObjectForKey:@"all_rate"];
        self.lrclink = [aDecoder decodeObjectForKey:@"lrclink"];
        self.song_id = [aDecoder decodeObjectForKey:@"song_id"];
        self.pic_small = [aDecoder decodeObjectForKey:@"pic_small"];
        self.pic_big = [aDecoder decodeObjectForKey:@"pic_big"];
        self.language = [aDecoder decodeObjectForKey:@"language"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.style = [aDecoder decodeObjectForKey:@"style"];
        self.filePath = [aDecoder decodeObjectForKey:@"filePath"];
        self.rate = [aDecoder decodeObjectForKey:@"rate"];
        self.fileSize = [aDecoder decodeObjectForKey:@"fileSize"];
        self.data_pic_big = [aDecoder decodeObjectForKey:@"data_pic_big"];
        self.data_pic_small = [aDecoder decodeObjectForKey:@"data_pic_small"];
        self.lyric = [aDecoder decodeObjectForKey:@"lyric"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.artist_id forKey:@"artist_id"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.all_rate forKey:@"all_rate"];
    [aCoder encodeObject:self.lrclink forKey:@"lrclink"];
    [aCoder encodeObject:self.song_id forKey:@"song_id"];
    [aCoder encodeObject:self.pic_small forKey:@"pic_small"];
    [aCoder encodeObject:self.pic_big forKey:@"pic_big"];
    [aCoder encodeObject:self.language forKey:@"language"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.style forKey:@"style"];
    [aCoder encodeObject:self.rate forKey:@"rate"];
    [aCoder encodeObject:self.fileSize forKey:@"fileSize"];
    [aCoder encodeObject:self.data_pic_small forKey:@"data_pic_small"];
    [aCoder encodeObject:self.data_pic_big forKey:@"data_pic_big"];
    [aCoder encodeObject:self.lyric forKey:@"lyric"];
}

@end
