//
//  MYZPageController.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYZPageProtocol.h"

#define KMYZ_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define KMYZ_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define KMYZ_STATUSBARHEIGHT ([MYZPageController iPhoneX]?44.0:20.0)
#define KMYZ_NAVSTATUSBAR_HEIGHT (KMYZ_STATUSBARHEIGHT+44.0)

@interface MYZPageController : UIViewController

@property (nonatomic, weak) id<MYZPageDateSource> dataSource;
@property (nonatomic, weak) id<MYZPageDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

+ (BOOL)iPhoneX;

@end
