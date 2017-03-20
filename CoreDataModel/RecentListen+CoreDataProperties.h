//
//  RecentListen+CoreDataProperties.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/10.
//  Copyright © 2016年 Xavier. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RecentListen.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentListen (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *songid;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *webSongId;

@end

NS_ASSUME_NONNULL_END
