//
//  NSString+ConvertToObjectID.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/10.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSString (ConvertToObjectID)
-(NSManagedObjectID *)convertToObjectIDForcoordinator:(NSPersistentStoreCoordinator *)coordinator;
@end
