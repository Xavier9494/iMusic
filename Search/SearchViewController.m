//
//  SearchViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/25.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "SearchViewController.h"
#import "PlayViewController.h"
#import "CatagoryListTableViewCell.h"
#import "CatagoryListOperationView.h"
#import "SearchResultSongModel.h"
#import "ApiParser.h"

@interface SearchViewController()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UISearchBar * _rSearchBar;
}

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,assign) NSInteger selectedCell;
@property(nonatomic,strong) UIView * searchMaskView;
@property(nonatomic,strong) CatagoryListOperationView * operationView;

@end

@implementation SearchViewController
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
 
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索歌曲";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _selectedCell = -1;
    
    _rSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    
    self.tableView.tableHeaderView = _rSearchBar;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CatagoryListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _rSearchBar.delegate = self;
}

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
    
    return cell;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
  [self.view addSubview:self.searchMaskView];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchMaskView removeFromSuperview];
}

-(UIView *)searchMaskView
{
    if (_searchMaskView == nil) {
        _searchMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + 60, self.view.bounds.size.width, self.view.bounds.size.height - 64 -60)];
        [_searchMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)]];
    }
    return _searchMaskView;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * searchText = searchBar.text;
    
    if (searchText.length == 0) {
        return;
    }
    
    if (({
        NSRange range = [searchText rangeOfString:@"\\W" options:NSRegularExpressionSearch];
        range.location != NSNotFound;
    })) {
        return;
    }
    
    [[ApiParser sharedParser] searchSongByKeyword:searchText block:^(NSArray *array) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array];
        [self.tableView reloadData];
    }];
}

-(void)endEditing
{
    [_rSearchBar endEditing:YES];
}

-(void)playMusic:(UITapGestureRecognizer *)tap
{
    [PlayViewController sharedPlayViewController].currentPlayList = self.dataSource;
    [PlayViewController sharedPlayViewController].currentPlaySong = _selectedCell;
    [self presentViewController:[PlayViewController sharedPlayViewController] animated:YES completion:nil];
}

-(void)collectMusic:(UITapGestureRecognizer *)tap
{
    NSLog(@"collectMusic is call");
}

-(void)downloadMusic:(UITapGestureRecognizer *)tap
{
    NSLog(@"downloadMusic is call");
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

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = nil;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
