//
//  MainNavView.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/27.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavBottomView.h"
#import "MainNavTopView.h"

@interface MainNavView : UIView
@property (weak, nonatomic) IBOutlet UILabel *songCountLabel;
@property (weak, nonatomic) IBOutlet MainNavBottomView *navView;
@property (weak, nonatomic) IBOutlet MainNavTopView *MainNavTopView;

@end
