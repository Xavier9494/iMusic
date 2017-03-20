//
//  ApiParser.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/2.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "CommonHeader.h"
#import "SongListModel.h"
#import "SongModel.h"
#import "ArtistorModel.h"

typedef void(^returnData)(NSArray * array);
typedef void(^returnInstance)(id data);

@interface ApiParser : NSObject

+(ApiParser *)sharedParser;

-(void)songOfList:(NSInteger)listId offset:(NSInteger)offset count:(NSInteger)count block:(returnData)block;
-(void)searchSongByKeyword:(NSString *)keyword block:(returnData)block;
-(void)songUrl:(NSInteger)songId block:(returnInstance)block;
-(void)lrcOfSong:(NSInteger)songId block:(returnInstance)block;
-(void)songDownInfo:(NSInteger)songId block:(returnInstance)block;

@end
