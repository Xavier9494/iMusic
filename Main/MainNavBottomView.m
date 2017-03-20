//
//  MainNavBottomView.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/28.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "MainNavBottomView.h"

@implementation MainNavBottomView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8] setStroke];
    CGContextSetLineWidth(ctx, 1);
    
    CGFloat drawHeight = 0;
    CGFloat width = self.bounds.size.width;
    CGFloat originX = 10;
    
    CGContextMoveToPoint(ctx, originX, drawHeight);
    CGContextAddLineToPoint(ctx, width - originX, drawHeight);
    
    CGContextStrokePath(ctx);
    
}
@end
