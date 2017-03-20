//
//  Song+CoreDataProperties.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/10.
//  Copyright © 2016年 Xavier. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)<NSCoding>

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSData *model;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
