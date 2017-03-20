//
//  PlayListViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/4.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "PlayListViewController.h"
#import "SongTableViewCell.h"
#import "PlayViewController.h"
#import "CatagoryListOperationView.h"
#import "Song.h"
#import "DownloadRecord.h"

@interface PlayListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    numberOfPlayList _numberOfPlayList;
    modelOfIndexPath _modelOfIndexPath;
}

@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.playList.delegate = self;
    self.playList.dataSource = self;
    //self.playList.tableFooterView = [[UIView alloc]init];
    self.playList.backgroundColor = [UIColor clearColor];
    
    [self.playList registerNib:[UINib nibWithNibName:NSStringFromClass([SongTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh
{
    [self.playList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _numberOfPlayList();
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_numberOfPlayList() == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"none"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"当前播放列表为空";
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    }else{
        SongTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        SongModel * model = _modelOfIndexPath(indexPath);
        if ([model isKindOfClass:[Song class]]) {
            model = [NSKeyedUnarchiver unarchiveObjectWithData:((Song *)model).model];
        }else if ([model isKindOfClass:[DownloadRecord class]]) {
            model = [NSKeyedUnarchiver unarchiveObjectWithData:((DownloadRecord *)model).model];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.songName.textColor = [UIColor whiteColor];
        cell.singerName.textColor = [UIColor whiteColor];
        cell.songName.text = model.title;
        cell.singerName.text = model.author;
        
        cell.selectedBackgroundView = ({UIView * view = [[UIView alloc]init];view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];view;});
        cell.OperationView.hidden = YES;
        cell.moreButton.hidden = YES;
        
        return cell;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PlayViewController sharedPlayViewController].currentPlaySong = indexPath.item;
}

-(void)setNumberOfPlayList:(NSInteger(^)(void))numberOfPlayList
{
    if (_numberOfPlayList) {
        _numberOfPlayList = nil;
    }
    _numberOfPlayList = [numberOfPlayList copy];
}

-(void)setModelOfIndexPath:(id (^)(NSIndexPath * indexPath))modelOfIndexPath
{
    if (_modelOfIndexPath) {
        _modelOfIndexPath = nil;
    }
    _modelOfIndexPath = [modelOfIndexPath copy];
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
