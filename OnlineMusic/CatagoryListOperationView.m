//
//  CatagoryListOperationView.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/3.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "CatagoryListOperationView.h"
#import "CommonHeader.h"
#import "Masonry.h"


@implementation CatagoryListOperationView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        
        [self addSubview:self.play];
        [self addSubview:self.collect];
        [self addSubview:self.download];
        
        WeakSelf(weakSelf);
        
        [self.play mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(10);
            make.left.equalTo(weakSelf).offset(10);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        [self.collect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.play);
            make.left.equalTo(weakSelf.play.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        [self.download mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.play);
            make.left.equalTo(weakSelf.collect.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.nextResponder touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.nextResponder touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   //[self.nextResponder touchesMoved:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.nextResponder touchesCancelled:touches withEvent:event];
}



-(CommonButton1 *)play
{
    if (_play == nil) {
        _play = [[CommonButton1 alloc]init];
        _play.iTitle.textColor = [UIColor whiteColor];
    }
    return _play;
}

-(CommonButton1 *)collect
{
    if (_collect == nil) {
        _collect = [[CommonButton1 alloc]init];
        _collect.iTitle.textColor = [UIColor whiteColor];
    }
    return _collect;
}

-(CommonButton1 *)download
{
    if (_download == nil) {
        _download = [[CommonButton1 alloc]init];
        _download.iTitle.textColor = [UIColor whiteColor];
    }
    return _download;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
