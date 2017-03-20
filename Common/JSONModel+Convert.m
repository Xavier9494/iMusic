//
//  JSONModel+Convert.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/12.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "JSONModel+Convert.h"

@implementation JSONModel (Convert)
-(id)initWithJSONData:(NSData *)data
{
    return [[[self class]alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] error:nil];
}
@end
