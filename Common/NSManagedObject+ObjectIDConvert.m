//
//  NSManagedObject+ObjectIDConvert.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/10.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "NSManagedObject+ObjectIDConvert.h"

@implementation NSManagedObject (ObjectIDConvert)
-(NSString *)StringOfObjectID
{
    return self.objectID.URIRepresentation.absoluteString;
}
@end
