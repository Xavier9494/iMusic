//
//  ConfigureManager.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/25.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigureManager : NSObject
+(ConfigureManager *)sharedConfigureManager;

-(NSString *)theme;
-(void)setTheme:(NSString *)theme;


@end
