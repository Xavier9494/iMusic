//
//  OnlineMusicViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/1.
//  Copyright © 2016年 Xavier. All rights reserved.
//
#import "CommonHeader.h"
#import "UIImageView+WebCache.h"
#import "OnlineMusicViewController.h"
#import "MXScrollView.h"
#import "Masonry.h"
#import "OnlineMusicTableViewCell.h"
#import "AFNetworking.h"
#import "SongListModel.h"
#import "SongModel.h"
#import "ArtistorModel.h"
#import "CatagoryListTableViewController.h"
#import "AppDelegate.h"

@interface OnlineMusicViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic, strong) MXScrollView *scroll;
@property(nonatomic,strong) NSDictionary * listTypeDict;

@end

@implementation OnlineMusicViewController

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
    // Do any additional setup after loading the view from its nib.
    [self initBaseLayout];
    [self loadData:0];
}

-(void)loadData:(NSInteger)order
{
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * key = self.listTypeDict.allKeys[order];
    NSNumber * value = self.listTypeDict[key];
    
    [mgr GET:[NSString stringWithFormat:URL(PARAM_LIST),[value integerValue],3,0] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray * songListArray = dataDict[@"song_list"];
        NSMutableArray * songModelArray = [NSMutableArray array];
        
        [songListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SongModel * model = [[SongModel alloc]initWithDictionary:obj error:nil];
            [songModelArray addObject:model];
        }];
        
        NSDictionary * billboardDict = dataDict[@"billboard"];
        SongListModel * model = [[SongListModel alloc]init];
        model.pic = billboardDict[@"pic_s260"];
        model.listId = [value integerValue];
        
        model.listName = key;
        model.top3 = songModelArray;
        [self.dataSource addObject:model];
        
        if (order == self.listTypeDict.count -1) {
            [self.tableView reloadData];
            return ;
        }
        
        [self loadData:order+1];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)initBaseLayout {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OnlineMusicTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 60, 0));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    //CMCyclickScroll
    _scroll = [[MXScrollView alloc] initWithRootTableView:_tableView height:150];
    _scroll.animotionDirection = kCMTransitionDirectionRandom;
    _scroll.animotionType = kCMTransitionRandom;
    _scroll.scrollIntervalTime = 5;
    _scroll.images =  @[
                        [UIImage imageNamed:@"03087bf40ad162d941483cbc16dfa9ec8b13cde8.jpg"],
                        [UIImage imageNamed:@"bd3eb13533fa828bf511fe5cfa1f4134970a5a5a.jpg"],
                        [UIImage imageNamed:@"1c950a7b02087bf4d8c72857f5d3572c11dfcf61.jpg"]
                        ];
    [_scroll setTapImageHandle:^(NSInteger index) {
        
    }];
    
    
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_scroll stretchingImage];
}

#pragma mark - tabelView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OnlineMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SongListModel * model = self.dataSource[indexPath.item];
    
    NSString * pic;
    if (![model.pic isEqualToString:@""]) {
        pic = model.pic;
    }else{
        if (model.top3.count > 0) {
            SongModel * song = model.top3[0];
            pic = song.pic_small;
        }
    }

    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:pic]];
    
    cell.cellTitleLabel.text = model.listName;
    
    for (int i = 0;i < model.top3.count;i ++) {
        SongModel * song = model.top3[i];
        if (i == 0) {
           cell.firstSong.text = [NSString stringWithFormat:@"%@ - %@",song.author,song.title];
        }
        if (i == 1) {
            cell.secondSong.text = [NSString stringWithFormat:@"%@ - %@",song.author,song.title];
        }
        if (i == 2) {
            cell.thirdSong.text = [NSString stringWithFormat:@"%@ - %@",song.author,song.title];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SongListModel * model = self.dataSource[indexPath.item];
    
    CatagoryListTableViewController * listVc = [[CatagoryListTableViewController alloc]init];
    listVc.listId = model.listId;
    
    AppDelegate * de = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [de.navVc pushViewController:listVc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark lazy load

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(NSDictionary *)listTypeDict
{
    if (_listTypeDict == nil) {
        _listTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:@(1),@"新歌榜",
                         @(2),@"热歌榜",
                         @(11),@"摇滚榜",
                         @(12),@"爵士",
                         @(16),@"流行",
                         @(21),@"欧美金曲",
                         @(22),@"经典老歌榜",
                         @(23),@"情歌对唱",
                         @(24),@"影视金曲",
                         @(25),@"网络歌曲",nil];
    }
    return _listTypeDict;
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
