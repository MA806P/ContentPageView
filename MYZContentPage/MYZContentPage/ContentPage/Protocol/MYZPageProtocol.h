//
//  MYZPageProtocol.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYZPageController;

@protocol MYZPageDelegate <NSObject>

@optional

//交互切换回调
- (void)pageviewController:(MYZPageController*)pageController willTransitionFromVC:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
- (void)pageviewController:(MYZPageController*)pageController didTransitionFromVC:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
//非交互切换回调
- (void)pageviewController:(MYZPageController*)pageController willLeaveFromVC:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
- (void)pageviewController:(MYZPageController*)pageController didLeaveFromVC:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;

//横向滑动回调
- (void)scrollViewContentOffsetWithRatio:(CGFloat)ratio draging:(BOOL)draging;
//垂直滑动的回调
- (void)scrollWithPageOffset:(CGFloat)realOffset index:(NSInteger)index;

- (BOOL)cannotScrollWithPageOffset;

@end




@protocol MYZPageDateSource <NSObject>

@required
- (UIViewController *)controllerAtIndex:(NSInteger)index;
- (NSInteger)numberOfControllers;

@optional
- (BOOL)isSubPageCanScrollForIndex:(NSInteger)index; //这个页面是否可用
- (CGFloat)pageTopAtIndex:(NSInteger)index; //childController 的 scrollview 的 inset

@end





@protocol MYZPageSubControllerDataSource <NSObject>

@optional
- (UIScrollView *)preferScrollView;

@end
