//
//  MainViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/23.
//  Copyright © 2016年 Xavier. All rights reserved.
//
#import "Masonry.h"

#import "MainViewController.h"
#import "MainNavView.h"
#import "MainOnlineMusicView.h"
#import "CommonHeader.h"
#import "OnlineMusicViewController.h"
#import "AppDelegate.h"
#import "SongListManager.h"

@interface MainViewController ()
@property(nonatomic,strong) MainNavView * mainNavView;
@property(nonatomic,strong) MainOnlineMusicView * mainOnlineMusicView;
@end

@implementation MainViewController

-(instancetype)init
{
    if (self) {
        self = [super init];
        self.type = BaseViewControllerTypeWithSearchBar;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mainNavView.songCountLabel.text = [NSString stringWithFormat:@"%lu",[[SongListManager sharedManager] countOfSongs]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _mainNavView = [[[NSBundle mainBundle] loadNibNamed:@"MainNavView" owner:nil options:nil] lastObject];
    [self.view addSubview:_mainNavView];
    WeakSelf(weakSelf);
    [_mainNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(72);
        make.left.equalTo(weakSelf.view).offset(0);
        make.width.equalTo(weakSelf.view);
        make.height.mas_equalTo(200);
    }];
    
    _mainOnlineMusicView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MainOnlineMusicView class]) owner:nil options:nil] lastObject];
    [self.view addSubview:_mainOnlineMusicView];
    [_mainOnlineMusicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainNavView.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
        make.height.mas_equalTo(100);
    }];
    [_mainOnlineMusicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOnlineMusicVc)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openOnlineMusicVc
{
    OnlineMusicViewController * onlineVc = [[OnlineMusicViewController alloc]init];
    AppDelegate * de = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [de.navVc pushViewController:onlineVc animated:YES];
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
