//
//  BaseViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/22.
//  Copyright © 2016年 Xavier. All rights reserved.
//
#import "Masonry.h"

#import "BaseViewController.h"
#import "ConfigureManager.h"
#import "SearchViewController.h"
#import "CommonHeader.h"
#import "PlayViewController.h"


@interface BaseViewController ()<UISearchBarDelegate>


@end

@implementation BaseViewController

-(instancetype)init
{
    if (self = [super init]) {
        _ade = [UIApplication sharedApplication].delegate;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self judgesShowReturnButton];
    [self reloadBgView];
    [self judgePatternColor];
    [self loadControlBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (_type) {
        case BaseViewControllerTypeNone:
        {
            [self loadWithNone];
        }
            break;
        case BaseViewControllerTypeWithBack:
        {
            [self loadWtihBack];
        }
            break;
        case BaseViewControllerTypeWithSearchBar:
        {
            [self loadWithSearchBar];
        }
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Method

-(void)loadWithNone
{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)loadWtihBack
{
    [self loadWithNone];
    NSString * theme = [ConfigureManager sharedConfigureManager].theme;
    self.bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:theme]];
    self.bgView.frame = [UIScreen mainScreen].bounds;
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.bgView atIndex:0];
    
    self.maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor whiteColor];
    self.maskView.alpha = 0;
    [self.view insertSubview:self.maskView aboveSubview:self.bgView];
}

-(void)loadWithSearchBar
{
    [self loadWtihBack];
    if (self.navigationController) {
        self.searchBar = [[UISearchBar alloc]init];
        self.navigationItem.titleView = self.searchBar;
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.searchBar.placeholder = @"搜索歌曲";
        self.searchBar.delegate = self;
    }
}

-(void)reloadBgView
{
    self.bgView.image = [UIImage imageNamed:[ConfigureManager sharedConfigureManager].theme];
}

-(void)loadControlBar
{
    [self.view addSubview:[PlayViewController sharedPlayViewController].controlBar];
    
    WeakSelf(weakSelf);
    [[PlayViewController sharedPlayViewController].controlBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(60);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.width.equalTo(weakSelf.view);
    }];
    
    [[PlayViewController sharedPlayViewController].controlBar.superview layoutIfNeeded];
    
    [[PlayViewController sharedPlayViewController].controlBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(0);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
       [[PlayViewController sharedPlayViewController].controlBar.superview layoutIfNeeded];
    }];
    
}


#pragma mark action

-(void)judgePatternColor
{
    UIColor * color = [[UIColor colorWithPatternImage:self.bgView.image] colorWithAlphaComponent:1];
    self.navigationController.navigationBar.barTintColor = color;
}

-(void)judgesShowReturnButton
{
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(popVc)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}

-(void)openSearchVc
{
    SearchViewController * searchVc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

-(void)popVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark SearchBar Delegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == _searchBar) {
        [self openSearchVc];
    }
    return NO;
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
