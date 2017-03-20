//
//  MyDownLoadViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/8.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "MyDownLoadViewController.h"
#import "MyDownLoadTableViewCell.h"
#import "DownloadManager.h"
#import "PlayViewController.h"
#import "SongListManager.h"
#import "DownloadRecord.h"
#import "AFNetworking.h"

@interface MyDownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) NSMutableDictionary * rtSpeeds;
@property(nonatomic,strong) NSTimer * timer;
@property(nonatomic,strong) NSLock * locker;
@end

@implementation MyDownLoadViewController

-(instancetype)init
{
    if (self) {
        self = [super init];
        self.type = BaseViewControllerTypeNone;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

-(NSLock *)locker
{
    if (_locker == nil) {
        _locker = [[NSLock alloc]init];
    }
    return _locker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的下载";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadProgress) userInfo:nil repeats:YES];
    //[self.timer setFireDate:[NSDate distantFuture]];
}

-(void)reloadProgress
{
    for (int i = 0; i < self.dataSource.count; i++) {
        DownloadRecord * record = self.dataSource[i];
        if (record.state.integerValue == Downloading) {
            [self.tableview reloadData];
            [self.rtSpeeds setObject:[NSNumber numberWithFloat:0] forKey:@(i)];
        }
    }
}

-(void)loadData
{
    if (self.dataSource == nil) {
        self.dataSource = [NSMutableArray array];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[DownloadManager sharedManager].downTask];
    [self.tableview reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDownLoadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyDownLoadTableViewCell class]) owner:nil options:nil]lastObject];
    }
    return cell;
}

@synthesize rtSpeeds = _rtSpeeds;
-(NSMutableDictionary *)rtSpeeds
{
    [_locker lock];
    if (_rtSpeeds == nil) {
        _rtSpeeds = [[NSMutableDictionary alloc]init];
    }
    [_locker unlock];
    return _rtSpeeds;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"]) {
        DownloadRecord * record = (DownloadRecord *)object;
        NSInteger index = [self.dataSource indexOfObject:record];
        CGFloat kbps = [self.rtSpeeds[@(index)] floatValue];
        kbps += record.speed;
        [self.rtSpeeds setObject:[NSNumber numberWithFloat:kbps] forKey:@(index)];
    }
    
    if ([keyPath isEqualToString:@"state"]) {
        [self.tableview reloadData];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadRecord * record = self.dataSource[self.dataSource.count-1-indexPath.item];
    MyDownLoadTableViewCell * tcell = (MyDownLoadTableViewCell *)cell;
    tcell.songInfo.text = [NSString stringWithFormat:@"%@-%@",record.title,record.author];
    if (record.state.integerValue == Downloading) {
        tcell.downInfo.text = [NSString stringWithFormat:@"%.1fM:%.1fM 下载速度:%.1f kb/s",[record.currentSize floatValue],[record.totalSize floatValue],[self.rtSpeeds[@(indexPath.item)] floatValue]];
        tcell.downState.text = [NSString stringWithFormat:@"%.2f%%",[record.progress floatValue] * 100];
        tcell.progress.progress = [record.progress floatValue];
        [record addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        [record addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }else{
        if (record.state.integerValue == DownloadFail) {
            tcell.downState.text = @"失败";
        }
        if (record.state.integerValue == DownloadSuccess) {
            tcell.downState.text = @"成功";
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadRecord * record = self.dataSource[indexPath.item];
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    if (record.state.integerValue == DownloadSuccess) {
//        Song * song = [[SongListManager sharedManager] songById:record.songid];
//        [PlayViewController sharedPlayViewController].currentPlayList = [NSMutableArray arrayWithArray:@[song]];
//        [PlayViewController sharedPlayViewController].currentPlaySong = 0;
//        [self presentViewController:[PlayViewController sharedPlayViewController] animated:YES completion:nil];
    }
    if (record.state.integerValue == DownloadFail) {
        alertVc.message = @"该歌曲下载失败，是否要重新下载?";
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[DownloadManager sharedManager] downloadSongFile:[NSKeyedUnarchiver unarchiveObjectWithData:record.model] andAddTo:nil];
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    if (record.state.integerValue == Downloading) {
        alertVc.message = @"该歌曲正在下载,是否要取消?";
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AFHTTPRequestOperation * operation = [[DownloadManager sharedManager] operationOfRecord:record];
            [operation cancel];
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
