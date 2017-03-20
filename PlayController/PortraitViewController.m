//
//  PortraitViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/4.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "PortraitViewController.h"
#import "PlayViewController.h"
#import "CommonHeader.h"

@interface PortraitViewController ()
{

}
@property(nonatomic,strong) NSTimer * timer;
@end

@implementation PortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.bounds = [UIScreen mainScreen].bounds;
    
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    self.portrait.layer.cornerRadius = self.portrait.frame.size.width /2;
    self.portrait.layer.masksToBounds = YES;
    self.portrait.alpha = 0.8;
    
    
    [self createTimer];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        if ([change[@"new"] integerValue] == PlayStatePlaying) {
            [self timerStart];
        }else{
            [self timerStop];
        }
    }
}

-(void)createTimer
{
//    _timer = [NSTimer timerWithTimeInterval:1.f/36 target:self selector:@selector(rotatePortrait) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)timerStart
{
    if (_timer) {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

-(void)timerStop
{
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)rotatePortrait{
    WeakSelf(ws);
    ws.portrait.transform = CGAffineTransformRotate(self.portrait.transform, M_PI/180);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
