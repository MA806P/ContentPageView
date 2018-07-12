//
//  MYZTabController.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MYZPageProtocol.h"
#import "MYZTabProtocol.h"

@interface MYZTabController : UIViewController<MYZPageDateSource, MYZPageDelegate, MYZTabDataSource, MYZTabDelegate>

//适用于TAB纵向滑动的情况
@property (nonatomic, assign) CGFloat maxYPullDown;//往下拉 tab的最大值
@property (nonatomic, assign) CGFloat minYPullUp;//拉上拉 tab的最小值


//优先展示在哪个页面，reloadData后 会调用这个方法。
- (NSInteger)preferPageFirstAtIndex;

//单一tab 是否需要展示
- (BOOL)preferSingleTabNotShow;

//自定义TABView,最好遵循TabDelegate，TabDataSource,要不有些情况要重写
- (UIView *)customTabView;
//适用于Tab高度 变化的情况
- (void)reloadTabH:(BOOL)isTabScroll;
//需要完全刷新页面时调用这个接口
- (void)reloadData;


@end
