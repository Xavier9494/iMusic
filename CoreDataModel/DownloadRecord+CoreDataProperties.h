//
//  DownloadRecord+CoreDataProperties.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/10.
//  Copyright © 2016年 Xavier. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DownloadRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadRecord (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSNumber *currentSize;
@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, retain) NSString *fileExtension;
@property (nullable, nonatomic, retain) NSString *fileLink;
@property (nullable, nonatomic, retain) NSString *filePath;
@property (nullable, nonatomic, retain) NSNumber *free;
@property (nullable, nonatomic, retain) NSData *model;
@property (nullable, nonatomic, retain) NSNumber *progress;
@property (nullable, nonatomic, retain) NSString *songid;
@property (nullable, nonatomic, retain) NSNumber *state;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *totalSize;

@end

NS_ASSUME_NONNULL_END
