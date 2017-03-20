//
//  BaseView.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/29.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "BaseView.h"

@interface BaseView()
{
    UIColor * _beforeColor;
}

@end

@implementation BaseView


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:touches withEvent:event];
    
    _beforeColor = self.backgroundColor;
    UIColor * changedColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    self.backgroundColor = changedColor;
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesCancelled:touches withEvent:event];
    
    [self touchesEnded:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesEnded:touches withEvent:event];
    
    self.backgroundColor = _beforeColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
