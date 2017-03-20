//
//  SongListManager.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/7.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "SongListManager.h"


@interface SongListManager()
{
    __weak AppDelegate * _ade;
}

@end

static SongListManager * manager;

@implementation SongListManager

+(SongListManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

-(instancetype)init
{
    if (self = [super init]) {
        _ade = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

-(Song *)addSong:(SongModel *)songModel
{
    Song * song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:_ade.managedObjectContext];
    song.date = [NSDate date];
    song.title = songModel.title;
    song.model = [songModel toJSONData];
    
    [_ade saveContext];
    
    return song;
}

-(void)deleteSong:(Song *)song
{
    [_ade.managedObjectContext deleteObject:song];
    [_ade saveContext];
    [self removeSongFromAllList:song];
}

-(void)collectSongToList:(NSString *)listName song:(Song *)song
{
    SongList * songList = [self listByName:listName];
    NSMutableArray * idOfSongs;
    
    if (!songList.idOfSongs) {
        idOfSongs = [NSMutableArray array];
    }
    else{
        idOfSongs = [NSKeyedUnarchiver unarchiveObjectWithData:songList.idOfSongs];
    }
    
    [idOfSongs addObject:[song StringOfObjectID]];

    songList.idOfSongs = [NSKeyedArchiver archivedDataWithRootObject:idOfSongs];
    [_ade saveContext];
}

-(void)removeSongFromAllList:(Song *)song
{
    NSArray * allList = [self allList];
    WeakSelf(weakSelf);
    [allList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SongList * list = obj;
        [weakSelf deleteSongFromList:list.name song:song];
    }];
}

-(NSArray *)allList
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SongList"];
    NSArray * allList = [_ade.managedObjectContext executeFetchRequest:request error:nil];
    return allList;
}

-(void)deleteSongFromList:(NSString *)listName song:(Song *)song
{
    SongList * songList = [self listByName:listName];
    NSMutableArray * idOfSongs;
    
    if (!songList.idOfSongs) {
        idOfSongs = [NSMutableArray array];
    }
    else{
        idOfSongs = [NSKeyedUnarchiver unarchiveObjectWithData:songList.idOfSongs];
    }
    
    [idOfSongs removeObject:[song StringOfObjectID]];
    
    songList.idOfSongs = [NSKeyedArchiver archivedDataWithRootObject:idOfSongs];
    [_ade saveContext];
    
}

-(SongList *)listByName:(NSString *)listName
{
    SongList * songList;
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"SongList"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name=%@",listName];
    request.predicate = predicate;
    
    NSError * err;
    NSArray * responseArray = [_ade.managedObjectContext executeFetchRequest:request error:&err];
    songList = [responseArray lastObject];
    return songList;
}

-(NSMutableArray *)songsOfList:(NSString *)listName
{
    SongList * songList = [self listByName:listName];
    
    NSData * data = songList.idOfSongs;
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:songList.idOfSongs];
    NSMutableArray * msongs = [NSMutableArray arrayWithArray:array];
    NSMutableArray * songModels = [NSMutableArray array];
    [msongs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [songModels addObject: [_ade.managedObjectContext objectWithID:[obj convertToObjectIDForcoordinator:_ade.persistentStoreCoordinator]]];
    }];
    return songModels;
}

-(NSArray *)allSong
{
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Song"];
    return [_ade.managedObjectContext executeFetchRequest:request error:nil];
}

-(NSArray *)allSongWithSorter:(sortType)sorter
{
    if (sorter == sortDefault) {
        return [self allSong];
    }
    if (sorter == sortDateAsc || sorter == sortDateDes) {
        BOOL asc = sortDateAsc ? YES:NO;
        NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Song"];
        NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:asc];
        request.sortDescriptors = @[sorter];
        return [_ade.managedObjectContext executeFetchRequest:request error:nil];
    }
    return nil;
}

-(NSArray *)getAllSongFromList:(NSString *)listName
{
    SongList * list = [self getList:listName];
    NSArray * songsid = [NSKeyedUnarchiver unarchiveObjectWithData:list.idOfSongs];

    NSMutableArray * songs = [NSMutableArray array];
    [songsid enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [songs addObject:[obj convertToObjectIDForcoordinator:_ade.persistentStoreCoordinator]];
    }];
    
    return songs;
}

-(SongList *)getList:(NSString *)listName
{
    SongList * songList;
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"SongList"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name=%@",listName];
    request.predicate = predicate;
    
    NSError * err;
    NSArray * responseArray = [_ade.managedObjectContext executeFetchRequest:request error:&err];
    songList = [responseArray lastObject];
    
    if (err) {
        NSLog(@"%@",err);
        return nil;
    }
    return songList;
}

-(void)createSongList:(NSString *)name
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SongList"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name=%@",name];
    request.predicate = predicate;
    NSArray * result = [_ade.managedObjectContext executeFetchRequest:request error:nil];
    NSMutableString * newName ;
    if (result.count != 0) {
        NSRange range = [name rangeOfString:@"[0-9]$" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound ) {
            NSString * numString = [name substringWithRange:range];
            newName = [NSMutableString stringWithString:name];
            [newName replaceCharactersInRange:range withString:[NSString stringWithFormat:@"%ld",numString.integerValue +1]];
        }else{
            newName = [NSMutableString stringWithString:[name stringByAppendingString:@"2"]];
        }
    }
    SongList * songList = [NSEntityDescription insertNewObjectForEntityForName:@"SongList" inManagedObjectContext:_ade.managedObjectContext];
    songList.name = name;
    songList.idOfSongs = nil;
    
    [_ade saveContext];
}

-(void)deleteSongList:(NSString *)name
{
    SongList * songList = [self listByName:name];
    [_ade.managedObjectContext deleteObject:songList];
    [_ade saveContext];
}

-(NSArray *)songByName:(NSString *)name
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"title=%@",name];
    request.predicate = predicate;

    NSArray * songs = [_ade.managedObjectContext executeFetchRequest:request error:nil];
    return songs;
}

-(Song *)songById:(NSString *)songid
{
    return [_ade.managedObjectContext objectWithID:[songid convertToObjectIDForcoordinator:_ade.persistentStoreCoordinator]];
}

-(BOOL)isExistAtList:(NSString *)listname songid:(NSString *)songid
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SongList"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name=%@",listname];
    request.predicate = predicate;
    
    SongList * list = [[_ade.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    NSArray * idOfSongs = [NSKeyedUnarchiver unarchiveObjectWithData:list.idOfSongs];
    return [idOfSongs containsObject:songid];
}

-(void)addModelToMyLove:(SongModel *)songModel
{
    Song * song = [self addSong:songModel];
    [self addSongToMyLove:song];
}

-(void)addSongToMyLove:(Song *)song
{
    MyLove * record = [NSEntityDescription insertNewObjectForEntityForName:@"MyLove" inManagedObjectContext:_ade.managedObjectContext];
    record.songid = [song StringOfObjectID];
    [_ade saveContext];
}

-(void)removeSongFromMyLove:(Song *)song
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MyLove"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"songid=%@",song.StringOfObjectID];
    request.predicate = predicate;
    
    NSArray * records = [_ade.managedObjectContext executeFetchRequest:request error:nil];
    [records enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [_ade.managedObjectContext deleteObject:obj];
    }];
    [_ade saveContext];
}

-(void)addRecordToRecentWithTitle:(NSString *)title author:(NSString *)author songId:(NSString *)songId webSongId:(NSInteger)webSongId
{
    RecentListen * record = [NSEntityDescription insertNewObjectForEntityForName:@"RecentListen" inManagedObjectContext:_ade.managedObjectContext];
    record.title = title;
    record.author = author;
    record.songid = songId;
    record.webSongId = [NSNumber numberWithInteger:webSongId];
    [_ade saveContext];
}

-(void)removeRecordFromRecent:(MyLove *)record
{
    [_ade.managedObjectContext deleteObject:record];
    [_ade saveContext];
}

-(NSArray *)allMyLove
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"MyLove"];
    NSArray * idArr = [_ade.managedObjectContext executeFetchRequest:request error:nil];
    NSMutableArray * songArr = [[NSMutableArray alloc]init];
    WeakSelf(weakSelf);
    [idArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [songArr addObject:[weakSelf songById:((MyLove *)obj).songid]];
    }];
    return songArr;
}

-(NSArray *)allRecent
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"RecentListen"];
    NSArray * arr = [_ade.managedObjectContext executeFetchRequest:request error:nil];
    return arr;
}

-(NSInteger)countOfSongs
{
    NSArray * allSong = [self allSong];
    return [allSong count];
}

-(NSArray *)customQuery:(NSString *)entity predicate:(NSString *)predicate
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:entity];
    NSPredicate * oPredicate = [NSPredicate predicateWithFormat:predicate];
    request.predicate = oPredicate;
    return [_ade.managedObjectContext executeFetchRequest:request error:nil];
}

@end
