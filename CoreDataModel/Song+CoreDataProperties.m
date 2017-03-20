//
//  Song+CoreDataProperties.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/10.
//  Copyright © 2016年 Xavier. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song+CoreDataProperties.h"

@implementation Song (CoreDataProperties)

@dynamic date;
@dynamic model;
@dynamic title;

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.model = [aDecoder decodeObjectForKey:@"model"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.model forKey:@"model"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

@end
