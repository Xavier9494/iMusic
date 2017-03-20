//
//  UIAlertController+Addition.h
//  爱羽客
//
//  Created by Xavier's iCloud ID on 16/5/4.
//  Copyright © 2016年 com.tiptimes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileHeader.h"

@interface UIAlertController (Addition)
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle defaultBlock:(voidBlock)defaultBlock cancelBlock:(voidBlock)cancelBlock;

+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle defaultBlock:(voidBlock)defaultBlock defaultActionTitle:(NSString *)defaultActionTitle cancelBlock:(voidBlock)cancelBlock cancelActionTitle:(NSString *)cancelActionTitle;
@end
