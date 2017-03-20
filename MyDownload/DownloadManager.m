//
//  DownloadManager.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/7.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadRecord.h"
#import "SongListManager.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "ApiParser.h"
#import "SongListManager.h"

static DownloadManager * manager;
@interface DownloadManager()
{
    __weak AppDelegate * _ade;
}
@end
@implementation DownloadManager
+(DownloadManager *)sharedManager
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
        _downTask = [[NSMutableArray alloc]init];
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([DownloadRecord class])];
        [_downTask addObjectsFromArray:[_ade.managedObjectContext executeFetchRequest:request error:nil]];
    }
    return self;
}

-(void)downloadSongFile:(SongModel *)song andAddTo:(NSString *)listname
{
    DownloadRecord * record = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DownloadRecord class]) inManagedObjectContext:_ade.managedObjectContext];
    record.title = song.title;
    record.author = song.author;
    record.progress = [NSNumber numberWithFloat:0.f];
    record.state = @(Downloading);
    record.model = [NSKeyedArchiver archivedDataWithRootObject:song];
    [_ade saveContext];
    
    [self.downTask addObject:record];
    
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [[ApiParser sharedParser] songDownInfo:song.song_id.integerValue block:^(id data) {
        
        record.totalSize = [NSNumber numberWithFloat:[data[@"file_size"] integerValue] /1024/1024.f];
        record.fileLink = data[@"file_link"];
        record.fileExtension = data[@"file_extension"];
        record.free = data[@"free"];
        
        //NSLog(@"\n\n\nfilepath:%@",record.fileLink);
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:record.fileLink]];
        AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        NSString * appDir = _ade.applicationDocumentsDirectory.path;
        NSString * filePath = [appDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.%@",record.author,record.title,record.fileExtension]];
        NSLog(@"%@",filePath);
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
        
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            CGFloat speed = bytesRead/1024.f;
            CGFloat cSize = totalBytesRead/1024.f/1024.f;
            //NSLog(@"cSize:%f",cSize);
            CGFloat progress = (totalBytesRead*1.0f)/(totalBytesRead + totalBytesExpectedToRead);
            //NSLog(@"progress:%f",progress);
            
            record.speed = speed;
            record.currentSize = [NSNumber numberWithFloat:cSize];
            record.progress = [NSNumber numberWithFloat:progress];
        }];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            record.speed = 0;
            record.filePath = filePath;
            record.state = [NSNumber numberWithInteger:DownloadSuccess];
            
            //修改Song模型内部的SongModel
            Song * csong = [[SongListManager sharedManager] addSong:song];
            SongModel * songModel = [[SongModel alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:csong.model options:NSJSONReadingMutableContainers error:nil] error:nil];
            
            songModel.filePath = [filePath lastPathComponent];
            songModel.title = record.title;
            songModel.author = record.author;
            songModel.fileSize = record.totalSize;
            csong.model = songModel.toJSONData;
            
            //使下载记录指向本地歌曲
            record.songid = csong.StringOfObjectID;
            
            //检测是否需要将下载歌曲添加到某个列表
            if (listname) {
                if ([listname isEqualToString:@"MyLove"]) {
                    [[SongListManager sharedManager]addSongToMyLove:csong];
                }
                else{
                    [[SongListManager sharedManager]collectSongToList:listname song:csong];
                }
            }
            
            //保存环境
            [_ade saveContext];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            record.state = [NSNumber numberWithInteger:DownloadFail];
            record.speed = 0;
            [[NSFileManager defaultManager] removeItemAtPath:record.filePath error:nil];
            NSLog(@"%@",error);
            [_ade saveContext];
            
        }];
        [operation start];
    }];
}

-(id)operationOfRecord:(DownloadRecord *)record
{
    if (record.state != Downloading) {
        return nil;
    }
    return self.operations[record.songid];
}

-(void)dealloc
{
    [_ade saveContext];
}

@end
