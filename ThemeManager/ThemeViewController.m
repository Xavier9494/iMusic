//
//  ThemeViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/30.
//  Copyright © 2016年 Xavier. All rights reserved.
//
#import "AppDelegate.h"
#import "ThemeDetailViewController.h"
#import "ThemeViewController.h"

@interface ThemeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray * catagoryArray;
@end

@implementation ThemeViewController

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
    self.navigationItem.title = @"主题列表";
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.catagoryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.catagoryArray[indexPath.item];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectedBackgroundView = ({UIView * view = [[UIView alloc]init];view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];view;});
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeDetailViewController * detailVc = [[ThemeDetailViewController alloc]init];
    detailVc.key = self.catagoryArray[indexPath.item];
    
    AppDelegate * de = [UIApplication sharedApplication].delegate;
    [de.navVc pushViewController:detailVc animated:YES];
    
}

#pragma mark lazy load

-(NSArray *)catagoryArray
{
    if (_catagoryArray == nil) {
        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ThemeList.plist" ofType:nil]];
        _catagoryArray = [dict allKeys];
    }
    return  _catagoryArray;
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
