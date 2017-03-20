//
//  DownloadManager.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/7.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongModel.h"
#import "AFNetworking.h"
#import "Song.h"
@class DownloadRecord;

typedef enum : NSUInteger {
    Downloading,
    DownloadSuccess,
    DownloadFail,
} DownloadState;

@interface DownloadManager : NSObject

+(DownloadManager *)sharedManager;

-(void)downloadSongFile:(SongModel *)song andAddTo:(NSString *)listname;
-(AFHTTPRequestOperation *)operationOfRecord:(DownloadRecord *)record;

@property(nonatomic,strong) NSMutableArray * downTask;
@property(nonatomic,strong) NSMutableDictionary * operations;

@end
