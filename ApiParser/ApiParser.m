//
//  ApiParser.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/2.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "ApiParser.h"

@interface ApiParser()
@end

static ApiParser * parser;

@implementation ApiParser

+(ApiParser *)sharedParser
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[ApiParser alloc]init];
    });
    return parser;
}


-(void)songOfList:(NSInteger)listId offset:(NSInteger)offset count:(NSInteger)count block:(returnData)block
{
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [mgr GET:[NSString stringWithFormat:URL(PARAM_LIST),listId,offset,count] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * rawSongList = response[@"song_list"];
        NSMutableArray * songList = [NSMutableArray array];
        
        [rawSongList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SongModel * model = [[SongModel alloc]initWithDictionary:obj error:nil];
            [songList addObject:model];
        }];
        
        block(songList);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)lrcOfSong:(NSInteger)songId block:(returnInstance)block
{
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * url = [NSString stringWithFormat:URL(PARAM_LRC),songId];
    
    [mgr GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * lrc = response[@"lrcContent"];
        block(lrc);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)searchSongByKeyword:(NSString *)keyword block:(returnData)block
{
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * url = [NSString stringWithFormat:URL(PARAM_SEARCH),[keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [mgr GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * rawSongList;
        
        for (id obj in [response allValues]) {
            if ([obj isKindOfClass:[NSArray class]]) {
                rawSongList = obj;
                break;
            }
        }
        
        NSMutableArray * songList = [NSMutableArray array];
        
        [rawSongList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SongModel * model = [[SongModel alloc]init];
            
            model.song_id = obj[@"songid"];
            model.title = obj[@"songname"];
            model.author = obj[@"artistname"];
            
            [songList addObject:model];
        }];
        
        block(songList);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)songUrl:(NSInteger)songId block:(returnInstance)block
{
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * url = [NSString stringWithFormat:URL(PARAM_PLAY),songId];
    
    [mgr GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString * songFileUrl = (responseDict[@"bitrate"])[@"file_link"];
        block(songFileUrl);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)songDownInfo:(NSInteger)songId block:(returnInstance)block
{
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * url = [NSString stringWithFormat:URL(PARAM_DOWN),songId];
    
    NSLog(@"%lu",songId);
    
    [mgr GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * files = responseDict[@"bitrate"];
        if (files.count == 0) {
            block(nil);return;
        }
        NSDictionary * fileInfo = files[0];
        
        //绕过接口下载限制，如果是收费歌曲，则从播放接口下载歌曲
        if ([fileInfo[@"file_link"] isEqualToString:@""]) {
            [self songUrl:songId block:^(id data) {
                NSMutableDictionary * mFileInfo = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
                [mFileInfo setObject:data forKey:@"file_link"];
                block(mFileInfo);
            }];
        }else{
            block(fileInfo);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


@end
