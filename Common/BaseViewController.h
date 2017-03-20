//
//  BaseViewController.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/22.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

typedef enum : NSUInteger {
    BaseViewControllerTypeNone,
    BaseViewControllerTypeWithBack,
    BaseViewControllerTypeWithSearchBar
} BaseViewControllerType;

@interface BaseViewController : UIViewController
{
    __weak AppDelegate * _ade;
}
@property(nonatomic,assign) BaseViewControllerType type;
@property(nonatomic,strong) UIImageView * bgView;
@property(nonatomic,strong) UIView * maskView;
@property(nonatomic,strong) UISearchBar * searchBar;

-(void)loadControlBar;
-(void)reloadBgView;
@end
