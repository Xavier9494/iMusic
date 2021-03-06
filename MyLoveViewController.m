//
//  MyLoveViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/8.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "MyLoveViewController.h"
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

@interface MyLoveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,assign) NSInteger selectedCell;
@property(nonatomic,strong) CatagoryListOperationView * operationView;

@end

@implementation MyLoveViewController

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
    [self.dataSource addObjectsFromArray:[[SongListManager sharedManager] allMyLove]];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我喜欢";
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
    Song * model = self.dataSource[indexPath.item];
    cell.songName.text = model.title;
    SongModel * songModel = [NSKeyedUnarchiver unarchiveObjectWithData:model.model];
    cell.singerName.text = songModel.author;
    return cell;
}

-(void)playMusic:(UITapGestureRecognizer *)tap
{
    [PlayViewController sharedPlayViewController].currentPlayList = self.dataSource;
    [PlayViewController sharedPlayViewController].currentPlaySong = _selectedCell;
    [self presentViewController:[PlayViewController sharedPlayViewController] animated:YES completion:nil];
}

-(void)collectMusic:(UITapGestureRecognizer *)tap
{
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"请选择歌单" preferredStyle:UIAlertControllerStyleActionSheet];
    SongListManager * mgr = [SongListManager sharedManager];
    NSArray * lists = [mgr allList];
    for (SongList * list in lists) {
        [alertVc addAction:[UIAlertAction actionWithTitle:list.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self collectMusicWithListName:list.name];
        }]];
    }
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)collectMusicWithListName:(NSString *)name
{
    [[SongListManager sharedManager]collectSongToList:name song:self.dataSource[_selectedCell]];
}

-(CatagoryListOperationView *)operationView
{
    if (_operationView == nil) {
        _operationView = [[CatagoryListOperationView alloc]init];
        
        _operationView.play.iImage.image = [UIImage imageNamed:@"cm2_lay_icn_play"];
        _operationView.play.iTitle.text = @"播放";
        
        _operationView.collect.iTitle.text = @"添加";
        _operationView.collect.iImage.image = [UIImage imageNamed:@"cm2_lay_icn_fav@3x"];
        
        [_operationView.play addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMusic:)]];
        
        [_operationView.collect addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectMusic:)]];
        
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
