//
//  ProfileHeader.h
//  爱羽客
//
//  Created by tiptimes on 16/4/26.
//  Copyright © 2016年 com.tiptimes. All rights reserved.
//

#ifndef ProfileHeader_h
#define ProfileHeader_h

typedef void(^outBlock)(id data);
typedef id(^inBlock)(void);
typedef void(^voidBlock)(void);

#define kMainColorGreen [UIColor colorWithRed:(3/255.f) green:(163/255.f) blue:(17/255.f) alpha:1]
#define kMainColorRed [UIColor colorWithRed:(251/255.f) green:(82/255.f) blue:(0/255.f) alpha:1]
#define kMainColorYellow [UIColor colorWithRed:(245/255.f) green:(190/255.f) blue:(11/255.f) alpha:1]
#define kMainColorGray [UIColor colorWithRed:(243/255.f) green:(243/255.f) blue:(243/255.f) alpha:1]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kTargetScreenWidth 414

#define kDevelopMode 1

#if kDevelopMode
#define XVRLog(CtrlStr,...) NSLog(CtrlStr,__VA_ARGS__)
#else
#define XVRLog(CtrlStr,...)
#endif

#define WeakSelf(ws) __weak __typeof(&*self) ws = self;

#endif /* ProfileHeader_h */
