//
//  MainNavView.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/27.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "Masonry.h"

#import "MainNavView.h"
#import "CommonHeader.h"

#import "MyLoveViewController.h"
#import "SongListViewController.h"
#import "RecentListenViewController.h"
#import "MyDownLoadViewController.h"
#import "LocalSongViewController.h"
#import "AppDelegate.h"
#import "SongListManager.h"

@interface MainNavView()
{
    __weak AppDelegate * _ade;
}

@end

@implementation MainNavView

-(void)buttonTarget1
{
    MyLoveViewController * loveVc = [[MyLoveViewController alloc]init];
    [_ade.navVc pushViewController:loveVc animated:YES];
}

-(void)buttonTarget2
{
    SongListViewController * songListVc = [[SongListViewController alloc]init];
    [_ade.navVc pushViewController:songListVc animated:YES];
}

-(void)buttonTarget3
{
    MyDownLoadViewController * downVc = [[MyDownLoadViewController alloc]init];
    [_ade.navVc pushViewController:downVc animated:YES];
}

-(void)buttonTarget4
{
    RecentListenViewController * recentVc = [[RecentListenViewController alloc]init];
    [_ade.navVc pushViewController:recentVc animated:YES];
}

-(void)openLocalSongVc:(UITapGestureRecognizer *)ges
{
    LocalSongViewController * localVc = [[LocalSongViewController alloc]init];
    localVc.dataSource = [NSMutableArray arrayWithArray:[[SongListManager sharedManager]allSong]];
    [_ade.navVc pushViewController:localVc animated:YES];
}


-(void)awakeFromNib
{
    _ade = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self.MainNavTopView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLocalSongVc:)]];
    
    UIButton * button1 = [[UIButton alloc]init];
    [button1 setImage:[UIImage imageNamed:@"icon_main_nav_love"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonTarget1) forControlEvents:UIControlEventTouchUpInside];
    self.navView.button1 = button1;
    
    UIButton * button2 = [[UIButton alloc]init];
    [button2 setImage:[UIImage imageNamed:@"icon_main_nav_list"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonTarget2) forControlEvents:UIControlEventTouchUpInside];
    self.navView.button2 = button2;
    
    UIButton * button3 = [[UIButton alloc]init];
    [button3 setImage:[UIImage imageNamed:@"icon_main_nav_down"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonTarget3) forControlEvents:UIControlEventTouchUpInside];
    self.navView.button3 = button3;
    
    UIButton * button4 = [[UIButton alloc]init];
    [button4 setImage:[UIImage imageNamed:@"icon_main_nav_lastest"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonTarget4) forControlEvents:UIControlEventTouchUpInside];
    self.navView.button4 = button4;
    
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"我喜欢";
    label1.font = [UIFont systemFontOfSize:14];
    
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = @"我的歌单";
    label2.font = [UIFont systemFontOfSize:14];
    
    
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"我的下载";
    label3.font = [UIFont systemFontOfSize:14];
    
    UILabel * label4 = [[UILabel alloc]init];
    label4.text = @"最近播放";
    label4.font = [UIFont systemFontOfSize:14];
    
    
    UIView * view1 = [[UIView alloc]init];
    UIView * view2 = [[UIView alloc]init];
    UIView * view3 = [[UIView alloc]init];
    UIView * view4 = [[UIView alloc]init];
    
    [view1 addSubview:button1];[view1 addSubview:label1];
    [view2 addSubview:button2];[view2 addSubview:label2];
    [view3 addSubview:button3];[view3 addSubview:label3];
    [view4 addSubview:button4];[view4 addSubview:label4];
    
    [self.navView addSubview:view1];
    [self.navView addSubview:view2];
    [self.navView addSubview:view3];
    [self.navView addSubview:view4];
    
    
    WeakSelf(weakSelf);
    
    [view1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.navView);
        make.top.equalTo(weakSelf.navView);
        make.bottom.equalTo(weakSelf.navView);
        make.width.equalTo(view4);
    }];
    [view2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right);
        make.top.equalTo(weakSelf.navView);
        make.bottom.equalTo(weakSelf.navView);
        make.width.equalTo(view1);
    }];
    [view3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_right);
        make.top.equalTo(weakSelf.navView);
        make.bottom.equalTo(weakSelf.navView);
        make.width.equalTo(view2);
    }];
    [view4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3.mas_right);
        make.top.equalTo(weakSelf.navView);
        make.bottom.equalTo(weakSelf.navView);
        make.right.equalTo(weakSelf.navView);
        make.width.equalTo(view3);
    }];
    
    [button1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view1);
        make.centerY.equalTo(view1).offset(-10);
    }];
    [label1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button1);
        make.top.equalTo(button1.mas_bottom).offset(5);
    }];
    
    [button2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view2);
        make.centerY.equalTo(view2).offset(-10);
    }];
    [label2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button2);
        make.top.equalTo(button2.mas_bottom).offset(5);
    }];
    
    [button3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view3);
        make.centerY.equalTo(view3).offset(-10);
    }];
    [label3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button3);
        make.top.equalTo(button3.mas_bottom).offset(5);
    }];
    
    [button4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view4);
        make.centerY.equalTo(view4).offset(-10);
    }];
    [label4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button4);
        make.top.equalTo(button4.mas_bottom).offset(5);
    }];
}


@end
