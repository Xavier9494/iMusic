//
//  CommonButton1.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/3.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "CommonButton1.h"
#import "Masonry.h"
#import "CommonHeader.h"

@implementation CommonButton1

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0,60, 60);
        self.iTitle.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.iTitle];
        [self addSubview:self.iImage];
        
        WeakSelf(weakSelf);
        
        
        [self.iImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
           make.top.equalTo(weakSelf).offset(0);
            make.width.equalTo(weakSelf);
            make.height.equalTo(weakSelf.mas_width);
        }];
        
        [self.iTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.equalTo(weakSelf.iImage.mas_bottom).offset(5);
        }];
    }
    return self;
}

-(UILabel *)iTitle
{
    if (_iTitle == nil) {
        _iTitle = [[UILabel alloc]init];
        _iTitle.font = [UIFont systemFontOfSize:12];
    }
    return _iTitle;
}

-(UIImageView *)iImage
{
    if (_iImage == nil) {
        _iImage = [[UIImageView alloc]init];
    }
    return _iImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
