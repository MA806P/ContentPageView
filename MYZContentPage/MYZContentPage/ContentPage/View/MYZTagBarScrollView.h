//
//  MYZTagBarScrollView.h
//  MYZContentPage
//
//  Created by MA806P on 2018/7/12.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYZTabProtocol.h"

@interface MYZTagBarScrollView : UIScrollView

@property (nonatomic, weak, readonly) id<MYZTabDataSource> tabDataSource;
@property (nonatomic, weak, readonly) id<MYZTabDelegate> tabDelegate;
@property (assign, nonatomic) BOOL markViewScroll;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<MYZTabDataSource>)dataSource delegate:(id<MYZTabDelegate>)delegate;

- (void)markViewScrollToContentRatio:(CGFloat)contentRatio;
- (void)markViewScrollToIndex:(NSInteger)index;
- (void)reloadHighlightToIndex:(NSInteger)index;
- (void)scrollTagToIndex:(NSUInteger)toIndex;
- (void)reloadTabBarTitleColor;


@end
