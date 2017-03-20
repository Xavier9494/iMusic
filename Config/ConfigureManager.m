//
//  ConfigureManager.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/25.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "ConfigureManager.h"

static ConfigureManager * sharedConfigreManager;
static NSString * configFilePath;

@interface ConfigureManager()
{
    NSMutableDictionary * _configDictionary;
}

@end

@implementation ConfigureManager
+(ConfigureManager *)sharedConfigureManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configFilePath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
        sharedConfigreManager = [[self alloc]init];
    });
    return sharedConfigreManager;
}

-(instancetype)init
{
    if (self) {
        self = [super init];
        [self readData];
    }
    return self;
}

-(void)readData
{
    _configDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:configFilePath];
}

-(void)saveData
{
    [_configDictionary writeToFile:configFilePath atomically:YES];
}

#pragma Property

-(NSString *)theme
{
    [self readData];
    return _configDictionary[@"theme"];
}

-(void)setTheme:(NSString *)theme
{
    [_configDictionary setValue:theme forKey:@"theme"];
    [self saveData];
}

@end
