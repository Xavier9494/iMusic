//
//  NSString+ConvertToObjectID.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/10.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "NSString+ConvertToObjectID.h"

@implementation NSString (ConvertToObjectID)
-(NSManagedObjectID *)convertToObjectIDForcoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    return [coordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:self]];
}
@end
