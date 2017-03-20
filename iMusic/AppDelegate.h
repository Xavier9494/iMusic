//
//  AppDelegate.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/21.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,weak,readonly) UINavigationController * navVc;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

