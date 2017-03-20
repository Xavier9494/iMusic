//
//  ControlBar.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/28.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "ControlBar.h"
#import "PlayViewController.h"

@implementation ControlBar

-(void)awakeFromNib
{
    self.singerImageView.layer.cornerRadius = 24;
    //[self.singerImageView.layer masksToBounds];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPlayVc:)]];
}

-(void)openPlayVc:(UITapGestureRecognizer *)ges
{
    UIViewController * tvc ;
    for (UIView * next = self.superview ; next; next = [next superview]) {
        UIResponder * vc = next.nextResponder;
        if ([vc isKindOfClass:[UIViewController class]]) {
            tvc = (UIViewController *)vc;break;
        }
    }
    
    if (tvc == [PlayViewController sharedPlayViewController]) {
        return;
    }
//    UIViewController * presentVc = [tvc presentingViewController];
//    if (presentVc == [PlayViewController sharedPlayViewController]) {
//        return;
//    }
//    
//    presentVc = [tvc presentedViewController];
//    if (presentVc == [PlayViewController sharedPlayViewController]) {
//        return;
//    }
    
    if (tvc) {
        [tvc presentViewController:[PlayViewController sharedPlayViewController] animated:YES completion:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
