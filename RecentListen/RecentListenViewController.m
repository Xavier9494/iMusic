//
//  RecentListenViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/8.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "RecentListenViewController.h"
#import "SongTableViewCell.h"
#import "SongListManager.h"
#import "DownloadManager.h"
#import "SongListManager.h"
#import "PlayViewController.h"
#import "SongList.h"
#import "Masonry.h"
#import "CommonHeader.h"
#import "ApiParser.h"
#import "CatagoryListOperationView.h"
#import "RecentListen.h"

@interface RecentListenViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,assign) NSInteger selectedCell;
@property(nonatomic,strong) CatagoryListOperationView * operationView;
@end

@implementation RecentListenViewController

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
    [self loadData];
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
    }
    return _tableView;
}

-(void)loadData
{
    if (self.dataSource == nil) {
        self.dataSource = [[NSMutableArray alloc]init];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[[SongListManager sharedManager] allRecent]];
    
    WeakSelf(ws);
    [self.dataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [ws.dataSource indexOfObject:obj1] < [ws.dataSource indexOfObject:obj2] ;
    }];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"最近播放";
    _selectedCell = -1;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SongTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedCell == indexPath.item) {
        __weak SongTableViewCell * ccell = (SongTableViewCell *)cell;
        [ccell.OperationView addSubview: self.operationView];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedCell == indexPath.item) {
        return 150.f;
    }
    return 60.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedCell == indexPath.item) {
        self.selectedCell = -1;
    }else{
        self.selectedCell = indexPath.item;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    RecentListen * model = self.dataSource[indexPath.item];
    cell.songName.text = model.title;
    cell.singerName.text = model.author;
    
    return cell;
}

-(void)playMusic:(UITapGestureRecognizer *)tap
{
    RecentListen * rl = self.dataSource[_selectedCell];
    if (rl.songid) {
        Song * song = [[SongListManager sharedManager] songById:rl.songid];
        [PlayViewController sharedPlayViewController].currentPlayList = [NSMutableArray arrayWithArray:@[song]];
        [PlayViewController sharedPlayViewController].currentPlaySong = 0;
        [self presentViewController:[PlayViewController sharedPlayViewController] animated:YES completion:nil];
    }else if(rl.webSongId){
        SongModel * songModel = [[SongModel alloc]init];
        songModel.song_id = [NSString stringWithFormat:@"%lu",[rl.webSongId integerValue]];
        songModel.title = rl.title;
        songModel.author = rl.author;
        [PlayViewController sharedPlayViewController].currentPlayList = [NSMutableArray arrayWithArray:@[songModel]];
        [PlayViewController sharedPlayViewController].currentPlaySong = 0;
        [self presentViewController:[PlayViewController sharedPlayViewController] animated:YES completion:nil];
    }
    
    
}

-(void)collectMusic:(UITapGestureRecognizer *)tap
{
    //[self downloadMusic:tap];
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"请选择歌单" preferredStyle:UIAlertControllerStyleActionSheet];
    
    SongListManager * mgr = [SongListManager sharedManager];
    
    NSArray * lists = [mgr allList];
    
    WeakSelf(ws);
    
    for (SongList * list in lists) {
        [alertVc addAction:[UIAlertAction actionWithTitle:list.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController * prompt = [UIAlertController alertControllerWithTitle:@"" message:@"添加到列表会自动下载？是否继续" preferredStyle:UIAlertControllerStyleAlert];
            [prompt addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //[self collectMusicWithListName:list.name];
            }]];
            [prompt addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [ws presentViewController:prompt animated:YES completion:nil];
        }]];
    }
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)collectMusicWithListName:(NSString *)name
{
    //[[DownloadManager sharedManager]downloadSongFile:self.dataSource[_selectedCell] andAddTo:name];
}

-(void)downloadMusic:(UITapGestureRecognizer *)tap
{
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"开始下载" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertVc animated:YES completion:^{
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }];
    
//    [[DownloadManager sharedManager] downloadSongFile:self.dataSource[_selectedCell] andAddTo:nil];
//    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"开始下载..." preferredStyle:UIAlertControllerStyleAlert];
//    [self presentViewController:alertVc animated:YES completion:^{
//        [alertVc dismissViewControllerAnimated:YES completion:nil];
//    }];
}

-(CatagoryListOperationView *)operationView
{
    if (_operationView == nil) {
        _operationView = [[CatagoryListOperationView alloc]init];
        
        _operationView.play.iImage.image = [UIImage imageNamed:@"cm2_lay_icn_play"];
        _operationView.play.iTitle.text = @"播放";
        
        _operationView.collect.iTitle.text = @"添加";
        _operationView.collect.iImage.image = [UIImage imageNamed:@"cm2_lay_icn_fav@3x"];
        
        _operationView.download.iTitle.text = @"下载";
        _operationView.download.iImage.image = [UIImage imageNamed:@"cm2_lay_icn_dld@3x"];
        
        [_operationView.play addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMusic:)]];
        
        [_operationView.collect addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectMusic:)]];
        
        [_operationView.download addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadMusic:)]];
        
    }
    return _operationView;
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
