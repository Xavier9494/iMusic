//
//  ThemeDetailViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/1.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "Masonry.h"
#import "ConfigureManager.h"

@interface ThemeDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) NSArray * dataSource;
@end

@implementation ThemeDetailViewController

-(instancetype)init
{
    if (self) {
        self = [super init];
        self.type = BaseViewControllerTypeWithBack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (({__block BOOL result = NO;[cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 999) {
            result = YES;
            *stop = YES;
        }
    }];!result;}))
    {
        UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.dataSource[indexPath.item]]];
        [cell addSubview:imageV];
        imageV.tag = 999;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 3, 3));
        }];
        cell.backgroundColor = [UIColor blackColor];
        cell.alpha = 0.8;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [ConfigureManager sharedConfigureManager].theme = self.dataSource[indexPath.item];
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"主题更换成功" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark lazy load

-(NSArray *)dataSource
{
    if (_dataSource == nil) {
        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ThemeList.plist" ofType:nil]];
        _dataSource = dict[self.key];
    }
    return _dataSource;
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
