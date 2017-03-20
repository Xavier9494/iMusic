//
//  SongListViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/8.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "SongListViewController.h"
#import "SongListManager.h"
#import "LocalSongViewController.h"
#import "Masonry.h"

@interface SongListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation SongListViewController

-(instancetype)init
{
    if (self) {
        self = [super init];
        self.type = BaseViewControllerTypeNone;
    }
    return self;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        [self refreshDataSource];
    }
    return _dataSource;
}

-(void)refreshDataSource
{
     _dataSource = [NSMutableArray arrayWithArray:[[SongListManager sharedManager]allList]];
    [self.tableView reloadData];
}

-(void)deleteSongList:(id)sender
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    NSInteger index = indexPath.item;
    NSString * listName = [self.dataSource[index] name];
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确认删除%@?",listName] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SongListManager * mgr = [SongListManager sharedManager];
        
        [mgr deleteSongList:listName];
        [self.dataSource removeObjectAtIndex:index];
        [self.tableView reloadData];
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的歌单";
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.item == 0) {
        cell.textLabel.text = @"新建歌单";
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        
        return cell;
    }
    
    SongList * list = self.dataSource[indexPath.item-1];
    cell.textLabel.text = list.name;
    [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSongList:)]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        WeakSelf(ws);
        UIAlertController * alertVc=[UIAlertController alertControllerWithTitle:@"新建歌单" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        __block UITextField * tf;
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            tf = textField;
            textField.placeholder = @"输入歌单名";
        }];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tf.text.length == 0) {
                UIAlertController * prompt = [UIAlertController alertControllerWithTitle:@"" message:@"歌单名不能为空" preferredStyle:UIAlertControllerStyleAlert];
                [ws presentViewController:prompt animated:YES completion:^{
                    [prompt dismissViewControllerAnimated:YES completion:nil];
                }];
            }else{
                if ([[SongListManager sharedManager] listByName:tf.text]) {
                    UIAlertController * prompt = [UIAlertController alertControllerWithTitle:@"" message:@"该歌单已经存在" preferredStyle:UIAlertControllerStyleAlert];
                    [ws presentViewController:prompt animated:YES completion:^{
                        [prompt dismissViewControllerAnimated:YES completion:nil];
                    }];
                    return ;
                }
                [[SongListManager sharedManager] createSongList:tf.text];
                
                [self refreshDataSource];
            }
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else{
        SongList * list = self.dataSource[indexPath.item-1];
    
        LocalSongViewController * localVc = [[LocalSongViewController alloc]init];
        localVc.dataSource = [[SongListManager sharedManager]songsOfList:list.name];
        [_ade.navVc pushViewController:localVc animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
