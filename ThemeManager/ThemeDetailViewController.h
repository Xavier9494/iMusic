//
//  ThemeDetailViewController.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/1.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ThemeDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,copy) NSString * key;
@end
