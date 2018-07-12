//
//  MYZTabProtocol.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYZTabDelegate <NSObject>

- (void)didPressTabForIndex:(NSInteger)index;//页面切换已在SPTabcontroller 实现

@end



@protocol MYZTabDataSource <NSObject>

@required
- (NSString *)titleForIndex:(NSInteger)index;

@optional
- (CGFloat)preferTabY;
- (CGFloat)preferTabX;
- (CGFloat)preferTabW;
- (CGFloat)preferTabHAtIndex:(NSInteger)index;
- (CGFloat)preferTabLeftOffset;
- (NSInteger)preferTabIndex;

- (NSInteger)numberOfTab;
- (CGFloat)tabWidthForIndex:(NSInteger)index;
- (CGFloat)tabTopForIndex:(NSInteger)index;//默认是0
- (UIColor *)tabBackgroundColor;

- (UIColor *)titleColorForIndex:(NSInteger)index;
- (UIColor *)titleHighlightColorForIndex:(NSInteger)index;
- (UIFont *)titleFontForIndex:(NSInteger)index;

- (CGFloat)markViewBottom;
- (CGFloat)markViewWidthForIndex:(NSInteger)index;
- (UIColor *)markViewColorForIndex:(NSInteger)index;
- (BOOL)isTabCanPressForIndex:(NSInteger)index;
- (BOOL)needMarkView;

@end
