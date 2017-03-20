//
//  UIAlertController+Addition.m
//  爱羽客
//
//  Created by Xavier's iCloud ID on 16/5/4.
//  Copyright © 2016年 com.tiptimes. All rights reserved.
//

#import "UIAlertController+Addition.h"

@implementation UIAlertController (Addition)
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle defaultBlock:(voidBlock)defaultBlock cancelBlock:(voidBlock)cancelBlock
{
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (defaultBlock) {
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            defaultBlock();
        }]];
    }
    if (cancelBlock) {
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancelBlock();
        }]];
    }
    return alertVc;
}

+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle defaultBlock:(voidBlock)defaultBlock defaultActionTitle:(NSString *)defaultActionTitle cancelBlock:(voidBlock)cancelBlock cancelActionTitle:(NSString *)cancelActionTitle
{
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (defaultBlock) {
        [alertVc addAction:[UIAlertAction actionWithTitle:defaultActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            defaultBlock();
        }]];
    }
    if (cancelBlock) {
        [alertVc addAction:[UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancelBlock();
        }]];
    }
    return alertVc;
}
@end
