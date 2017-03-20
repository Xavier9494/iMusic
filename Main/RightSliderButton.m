//
//  RightSliderButton.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/30.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "RightSliderButton.h"
#import "Masonry.h"
#import "CommonHeader.h"

@implementation RightSliderButton

-(instancetype)init
{
    self = [super init];
    if (self) {
        WeakSelf(weakSelf);
        
        [self addSubview:self.buttonTitleLabel];
        [self addSubview:self.buttonImageView];
        
        self.buttonTitleLabel.font = [UIFont systemFontOfSize:12];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 36));
        }];
        
        [self.buttonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
            make.width.mas_equalTo(36);
            make.left.equalTo(weakSelf).offset(5);
            make.centerY.equalTo(weakSelf);
        }];
        
        [self.buttonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
            make.right.equalTo(weakSelf.mas_right).offset(5);
            make.left.equalTo(weakSelf.buttonImageView.mas_right).offset(5);
            make.centerY.equalTo(weakSelf);
        }];
    }
    return self;
}



-(UIImageView *)buttonImageView
{
    if (_buttonImageView == nil) {
        _buttonImageView = [[UIImageView alloc]init];
    }
    return _buttonImageView;
}

-(UILabel *)buttonTitleLabel
{
    if (_buttonTitleLabel == nil) {
        _buttonTitleLabel = [[UILabel alloc]init];
    }
    return _buttonTitleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
