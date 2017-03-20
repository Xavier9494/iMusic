//
//  MyRightSliderViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/23.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "Masonry.h"
#import "UIViewController+MMDrawerController.h"

#import "ThemeViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"

#import "CommonHeader.h"
#import "MyRightSliderViewController.h"
#import "ConfigureManager.h"
#import "RightSliderCollectionViewCell.h"
#import "RightSliderButton.h"

@interface MyRightSliderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView * menuCollectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout * flowLayout;

@end

@implementation MyRightSliderViewController

-(void)viewWillAppear:(BOOL)animated
{
    NSString * theme = [ConfigureManager sharedConfigureManager].theme;
    UIImage * themeImage = [UIImage imageNamed:theme];
    UIColor * color = [[UIColor colorWithPatternImage:themeImage] colorWithAlphaComponent:0.3];
    self.view.backgroundColor = color;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.menuCollectionView];
    
    self.menuCollectionView.frame = CGRectMake(0, 0, 120, self.view.bounds.size.height - 100);
    
    _flowLayout.minimumLineSpacing = 10;
    
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.dataSource = self;
    
    [self.menuCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RightSliderCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"menuItem"];
    [self.menuCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"menuButton"];
    [self.menuCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.menuCollectionView.backgroundColor = [UIColor clearColor];
    
    
    
    
    UIView * footerView = [[UIView alloc]init];
    [self.view addSubview:footerView];
    
    WeakSelf(weakSelf);
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(100);
    }];
    
    UIView * whiteLine = [[UIView alloc]initWithFrame:CGRectMake(120 * 0.1 /2, 0, 120 * 0.9, 1)];
    whiteLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    [footerView addSubview:whiteLine];
    
    
    RightSliderButton * homeButton = [[RightSliderButton alloc]init];
    homeButton.buttonTitleLabel.text = @"返回";
    homeButton.buttonImageView.image = [UIImage imageNamed:@"icon_sidemenu_home"];
    homeButton.buttonTitleLabel.textColor = [UIColor whiteColor];
    [homeButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnHome)]];
    
    RightSliderButton * exitButton = [[RightSliderButton alloc]init];
    exitButton.buttonTitleLabel.text = @"退出";
    exitButton.buttonImageView.image = [UIImage imageNamed:@"icon_sidemenu_exit"];
    exitButton.buttonTitleLabel.textColor = [UIColor whiteColor];
    [exitButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitApplication)]];
    
    [self.view addSubview:homeButton];
    [self.view addSubview:exitButton];
    
    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.top.equalTo(footerView).offset(10);
    }];
    
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.top.equalTo(homeButton.mas_bottom).offset(10);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action

-(void)exitApplication
{
    exit(0);
}

-(void)returnHome
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

#pragma mark Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuButton" forIndexPath:indexPath];
        
        RightSliderButton * button = [[RightSliderButton alloc]init];
        button.buttonImageView.image = [UIImage imageNamed:@"icon_sidemenu_skin"];
        button.buttonTitleLabel.text = @"皮肤";
        button.buttonTitleLabel.textColor = [UIColor whiteColor];
        
        [cell addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(button.superview);
        }];
        
        return cell;
    }else if(indexPath.section == 1){
         RightSliderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuItem" forIndexPath:indexPath];

        if (indexPath.item == 0) {
            cell.cellImageView.image = [UIImage imageNamed:@"icon_sidemenu_search"];
            cell.cellTitleLabel.text = @"搜索";
        }
        if (indexPath.item == 1) {
            cell.cellImageView.image = [UIImage imageNamed:@"icon_sidemenu_timer"];
            cell.cellTitleLabel.text = @"定时";
        }
        if (indexPath.item == 2) {
            cell.cellImageView.image = [UIImage imageNamed:@"icon_sidemenu_setting"];
            cell.cellTitleLabel.text = @"设置";
        }
        
        return cell;
        
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self returnHome];
    
    if (indexPath.section == 0) {
        UINavigationController * navVc = (UINavigationController *)self.mm_drawerController.centerViewController;
        if(![navVc.topViewController isKindOfClass:[ThemeViewController class]])
        {
            ThemeViewController * themeVc = [[ThemeViewController alloc]init];
            [navVc pushViewController:themeVc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.item == 0) {
            UINavigationController * navVc = (UINavigationController *)self.mm_drawerController.centerViewController;
            if(![navVc.topViewController isKindOfClass:[SearchViewController class]])
            {
                SearchViewController * searchVc = [[SearchViewController alloc]init];
                [navVc pushViewController:searchVc animated:YES];
            }
        }
        if (indexPath.item == 1) {
            
        }
        if (indexPath.item == 2) {
            
        }
        if (indexPath.item == 3) {
            
        }
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view;
    
    view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (kind == UICollectionElementKindSectionFooter && indexPath.section == 0) {
        
        UIView * whiteLine = [[UIView alloc]initWithFrame:CGRectMake(220 * 0.1 /2, 0, 220 * 0.9, 1)];
        whiteLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        [view addSubview:whiteLine];
        
    }
    
    return view;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 1);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(220, 50);
    }else if(indexPath.section == 1){
        return CGSizeMake(100, 100);
    }
    return CGSizeZero;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(30, 0, 0, 0);
    }
    return UIEdgeInsetsZero;
}

#pragma mark lazy Load

-(UICollectionView *)menuCollectionView
{
    if (!_menuCollectionView) {
        _menuCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    }
    return _menuCollectionView;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    }
    return _flowLayout;
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
