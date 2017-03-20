
//
//  CatagoryListTableViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/3.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "Masonry.h"
#import "CommonHeader.h"
#import "ApiParser.h"
#import "CatagoryListTableViewController.h"
#import "CatagoryListTableViewCell.h"
#import "CatagoryListOperationView.h"
#import "DownloadManager.h"
#import "SongListManager.h"
#import "PlayViewController.h"
#import "SongList.h"

@interface CatagoryListTableViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _offset;
    NSInteger _count;
}
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,assign) NSInteger selectedCell;
@property(nonatomic,strong) CatagoryListOperationView * operationView;

@end

@implementation CatagoryListTableViewController

-(instancetype)init
{
    if (self) {
        self = [super init];
        self.type = BaseViewControllerTypeWithSearchBar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedCell = -1;
    
    _count = 20;
    [self loadData];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CatagoryListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 60, 0));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data

-(void)loadData
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    if (self.listId != 0) {
        [[ApiParser sharedParser] songOfList:self.listId offset:_offset count:_count block:^(NSArray *array) {
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
        }];
        _offset += _count;
    }
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedCell == indexPath.item) {
        return 150.f;
    }
    return 60.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedCell == indexPath.item) {
        __weak CatagoryListTableViewCell * ccell = (CatagoryListTableViewCell *)cell;
        [ccell.OperationView addSubview: self.operationView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CatagoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SongModel * model = self.dataSource[indexPath.item];
    cell.songName.text = model.title;
    cell.singerName.text = model.author;
    
//    [cell.moreButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMore:)]];
    
    if (indexPath.item >= self.dataSource.count * 0.8) {
        [self loadData];
    }
    return cell;
}

//-(void)tapMore:(UITapGestureRecognizer *)ges
//{
//    
//}

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
    WeakSelf(weakSelf);
    [alertVc addAction:[UIAlertAction actionWithTitle:@"新建歌单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __block UITextField * tf;
        UIAlertController * createSongListAlertVc = [UIAlertController alertControllerWithTitle:@"新建歌单" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [createSongListAlertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            tf = textField;
            textField.placeholder = @"歌单名";
        }];
        [createSongListAlertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tf.text.length != 0) {
               [[SongListManager sharedManager] createSongList:tf.text];
            }else{
                UIAlertController * errorAlertVc = [UIAlertController alertControllerWithTitle:@"" message:@"歌单名不允许为空" preferredStyle:UIAlertControllerStyleAlert];
                [errorAlertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [weakSelf presentViewController:errorAlertVc animated:YES completion:nil];
            }
            
        }]];
        [createSongListAlertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:createSongListAlertVc animated:YES completion:nil];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)collectMusicWithListName:(NSString *)name
{
    [[DownloadManager sharedManager]downloadSongFile:self.dataSource[_selectedCell] andAddTo:name];
}

-(void)downloadMusic:(UITapGestureRecognizer *)tap
{
    [[DownloadManager sharedManager] downloadSongFile:self.dataSource[_selectedCell] andAddTo:nil];
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"开始下载..." preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVc animated:YES completion:^{
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
