//
//  SongListManager.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/7.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongModel.h"
#import "Song.h"
#import "AppDelegate.h"
#import "Song+CoreDataProperties.h"
#import "SongList+CoreDataProperties.h"
#import "RecentListen+CoreDataProperties.h"
#import "MyLove+CoreDataProperties.h"
#import "MyLove.h"
#import "RecentListen.h"
#import "CommonHeader.h"
#import "NSString+ConvertToObjectID.h"
#import "NSManagedObject+ObjectIDConvert.h"

@class MyLove;

typedef enum : NSUInteger {
    sortDefault,
    sortDateAsc,
    sortDateDes
} sortType;

NS_ASSUME_NONNULL_BEGIN

@interface SongListManager : NSObject

+(SongListManager *)sharedManager;

-(Song *)addSong:(SongModel *)songModel;

-(void)deleteSong:(Song *)song;

-(void)collectSongToList:(NSString *)listName song:(Song *)song;

-(void)removeSongFromAllList:(Song *)song;

-(NSArray *)allList;

-(void)deleteSongFromList:(NSString *)listName song:(Song *)song;

-(SongList *)listByName:(NSString *)listName;

-(NSMutableArray *)songsOfList:(NSString *)listName;

-(NSArray *)allSong;

-(NSArray *)allSongWithSorter:(sortType)sorter;

-(NSArray *)getAllSongFromList:(NSString *)listName;

-(SongList *)getList:(NSString *)listName;

-(void)createSongList:(NSString *)name;

-(void)deleteSongList:(NSString *)name;

-(NSArray *)songByName:(NSString *)name;

-(Song *)songById:(NSString *)songid;

-(BOOL)isExistAtList:(NSString *)listname songid:(NSString *)songid;

-(void)addModelToMyLove:(SongModel *)songModel;

-(void)addSongToMyLove:(Song *)song;

-(void)removeSongFromMyLove:(Song *)song;

-(void)addRecordToRecentWithTitle:(NSString *)title author:(NSString *)author songId:(NSString *)songId webSongId:(NSInteger)webSongId;

-(void)removeRecordFromRecent:(MyLove *)record;

-(NSArray *)allMyLove;

-(NSArray *)allRecent;

-(NSInteger)countOfSongs;

-(NSArray *)customQuery:(NSString *)entity predicate:(NSString *)predicate;

@end


NS_ASSUME_NONNULL_END