//
//  MYZTagBarScrollView.m
//  MYZContentPage
//
//  Created by MA806P on 2018/7/12.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZTagBarScrollView.h"
#import "MYZPageTagView.h"

@interface MYZTagBarScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray<MYZPageTagView *> *tagViewsCache;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak, readwrite) id<MYZTabDataSource> tabDataSource;
@property (nonatomic, weak, readwrite) id<MYZTabDelegate> tabDelegate;

@end


@implementation MYZTagBarScrollView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<MYZTabDataSource>)dataSource delegate:(id<MYZTabDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        
        self.tabDataSource = dataSource;
        self.tabDelegate = delegate;
        
        self.contentSize = CGSizeZero;
        self.directionalLockEnabled = YES;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        
        [self __setupTagBarView];
        [self __setupMaskView];
        [self __setupFirstIndex];
    }
    return self;
}


#pragma mark - private method

- (void)__setupFirstIndex {
    NSInteger index = [self.tabDataSource respondsToSelector:@selector(preferTabIndex)]?[self.tabDataSource preferTabIndex]:0;
    self.index = index;
    [self scrollTagToIndex:index];
    [self markViewToIndex:index animatied:NO];
}

- (void)__setupMaskView {
    if ([self needMarkView]) {
        self.markView = [[UIView alloc] init];
        self.markView.frame = CGRectMake(0, [self.tabDataSource respondsToSelector:@selector(markViewBottom)]?[self.tabDataSource markViewBottom]:-13, [self.tabDataSource markViewWidthForIndex:self.index], 2);
        
        self.markView.layer.cornerRadius = 1.0;
        self.markView.layer.masksToBounds = YES;
        self.markView.backgroundColor = [self.tabDataSource markViewColorForIndex:self.index];
        [self addSubview:self.markView];
        self.markViewScroll = YES;
    }
}

- (void)__setupTagBarView {
    
    self.tagViewsCache = [NSMutableArray array];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    
    CGFloat preferTabOffset = 5;
    if (self.tabDataSource && [self.tabDataSource respondsToSelector:@selector(preferTabLeftOffset)]) {
        preferTabOffset = [self.tabDataSource preferTabLeftOffset];
    }
    
    CGFloat tabContentWidth = 0;
    for (int i = 0; i < [self.tabDataSource numberOfTab]; i++) {
        if ([self.tabDataSource respondsToSelector:@selector(tabWidthForIndex:)]) {
            tabContentWidth += [self.tabDataSource tabWidthForIndex:i];
        } else {
            tabContentWidth += 73;
        }
    }
    
    CGFloat offset = 0;
    if ( tabContentWidth + 2.0 * preferTabOffset > self.frame.size.width) {
        offset = preferTabOffset;
    } else {
        offset = (self.frame.size.width - tabContentWidth) * 0.5;
    }
    
    
    for (int i = 0; i < [self.tabDataSource numberOfTab]; i++) {
        CGFloat tagWidth = 73;
        if ([self.tabDataSource respondsToSelector:@selector(tabWidthForIndex:)]) {
            tagWidth = [self.tabDataSource tabWidthForIndex:i];
        }
        
        CGFloat top = 0;
        if ([self.tabDataSource respondsToSelector:@selector(tabTopForIndex:)]) {
            top = [self.tabDataSource tabTopForIndex:i];
        }
        
        MYZPageTagTitleView *titleView = [[MYZPageTagTitleView alloc] initWithFrame:CGRectMake(offset, top, tagWidth, self.frame.size.height)];
        if ([self.tabDataSource respondsToSelector:@selector(titleColorForIndex:)]) {
            titleView.normalTitleColor = [self.tabDataSource titleColorForIndex:i];
        }
        if ([self.tabDataSource respondsToSelector:@selector(titleHighlightColorForIndex:)]) {
            titleView.highlightedTitleColor = [self.tabDataSource titleHighlightColorForIndex:i];
        }
        titleView.title.text = [self.tabDataSource titleForIndex:i];
        titleView.title.font = [self.tabDataSource respondsToSelector:@selector(titleFontForIndex:)]? [self.tabDataSource titleFontForIndex:i]:[UIFont systemFontOfSize:15.0];
        titleView.tag = i;
        titleView.userInteractionEnabled = YES;
        [titleView addTarget:self action:@selector(pressTab:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleView];
        [self.tagViewsCache addObject:titleView];
        offset += tagWidth;
    }
    
    [self reloadHighlight];
    
    self.contentSize = CGSizeMake(offset, self.frame.size.height);
    if ([self.tabDataSource respondsToSelector:@selector(tabBackgroundColor)]) {
        self.backgroundColor = [self.tabDataSource tabBackgroundColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)pressTab:(UIControl *)sender {
    
    NSInteger i = sender.tag;
    [self.tabDelegate didPressTabForIndex:i];
    
    if  (self.index == i) {
        return;
    }
    
    if ([self.tabDataSource respondsToSelector:@selector(isTabCanPressForIndex:)] && ![self.tabDataSource isTabCanPressForIndex:i]) {
        return;
    }
    
    self.index = i;
    [self reloadHighlight];
    [self scrollTagToIndex:i];
    [self markViewToIndex:i animatied:YES];
}


- (void)reloadHighlight {
    for (int i=0;i<self.tagViewsCache.count;i++) {
        MYZPageTagView *view = (MYZPageTagView *)self.tagViewsCache[i];
        if (i == self.index) {
            [view highlightTagView];
        } else {
            [view unhighlightTagView];
        }
    }
}


//点击 和初始化使用
- (void)markViewToIndex:(NSInteger)index animatied:(BOOL)animated
{
    if  (index >= self.tagViewsCache.count || index < 0) {
        return;
    }
    
    if (![self needMarkView]) {
        [self reloadHighlight];
    } else {
        MYZPageTagView *nextTagView = self.tagViewsCache[index];
        if (animated) {
            __weak MYZTagBarScrollView *wScrollView =self;
            [UIView animateWithDuration:0.3 animations:^{
                __weak MYZTagBarScrollView *bScrollView =wScrollView;
                
                bScrollView.markView.center = CGPointMake(nextTagView.center.x, bScrollView.markView.center.y);
            } completion:^(BOOL finished) {
                __weak MYZTagBarScrollView *bScrollView =wScrollView;
                [bScrollView reloadHighlight];
            }];
        } else {
            
            MYZPageTagView *nextTagView = self.tagViewsCache[index];
            self.markView.center = CGPointMake(nextTagView.center.x, self.markView.center.y);
            [self reloadHighlight];
            
        }
        
    }
}

- (BOOL)needMarkView {
    return [self.tabDataSource respondsToSelector:@selector(needMarkView)] && [self.tabDataSource needMarkView];
}


- (void)setMarkViewWidth:(CGFloat)width {
    CGRect frame = self.markView.frame;
    self.markView.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}


#pragma mark - public method

//pageview滑动的接口
- (void)markViewScrollToContentRatio:(CGFloat)contentRatio {
    if (!self.markViewScroll) {
        return;
    }
    
    int fromIndex = ceil(contentRatio)-1;
    
    if ( fromIndex <0 || self.tagViewsCache.count <= fromIndex+1) {
        return;
    }
    
    CGFloat fromWidth =  [self.tabDataSource markViewWidthForIndex:fromIndex];
    CGFloat toWidth =  [self.tabDataSource markViewWidthForIndex:fromIndex+1];
    if (fromWidth != toWidth) {
        [self setMarkViewWidth:fromWidth + (toWidth-fromWidth)*(contentRatio-fromIndex)];
    }
    
    MYZPageTagView *curTagView = self.tagViewsCache[fromIndex];
    MYZPageTagView *nextTagView = self.tagViewsCache[fromIndex+1];
    
    
    MYZPageTagView *firstTagView = self.tagViewsCache.firstObject;
    MYZPageTagView *lastTagView = self.tagViewsCache.lastObject;
    CGFloat moveCenterX = curTagView.center.x+(contentRatio-fromIndex)*(nextTagView.center.x-curTagView.center.x);
    if (moveCenterX <= firstTagView.center.x) {
        moveCenterX = firstTagView.center.x;
    } else if (moveCenterX >= lastTagView.center.x) {
        moveCenterX = lastTagView.center.x;
    }
    
    self.markView.center = CGPointMake(moveCenterX, self.markView.center.y);
}
- (void)markViewScrollToIndex:(NSInteger)index {
    if (!self.markViewScroll) {
        return;
    }
    if  (index >= self.tagViewsCache.count || index < 0) {
        return;
    }
    
    MYZPageTagView *curTagView = self.tagViewsCache[index];
    [self setMarkViewWidth:[self.tabDataSource markViewWidthForIndex:index]];
    self.markView.center = CGPointMake(curTagView.center.x, self.markView.center.y);
    
}
- (void)reloadHighlightToIndex:(NSInteger)index {
    self.index = index;
    [self reloadHighlight];
}
- (void)scrollTagToIndex:(NSUInteger)toIndex {
    if (self.tagViewsCache.count <= toIndex || self.contentSize.width < self.frame.size.width) {
        return;
    }
    MYZPageTagView *nextTagView = self.tagViewsCache[toIndex];
    
    CGFloat tagExceptInScreen = [UIScreen mainScreen].bounds.size.width - nextTagView.frame.size.width;
    CGFloat tagPaddingInScreen = tagExceptInScreen / 2.0;
    CGFloat offsetX = MAX(0, MIN(nextTagView.frame.origin.x - tagPaddingInScreen, self.tagViewsCache.lastObject.frame.origin.x - tagExceptInScreen));
    
    CGPoint nextPoint = CGPointMake(offsetX, 0);
    
    //the last one
    if (toIndex == self.tagViewsCache.count - 1 && toIndex != 0) {
        nextPoint.x = self.contentSize.width - self.frame.size.width + self.contentInset.right;
    }
    
    [self setContentOffset:nextPoint animated:YES];
}
- (void)reloadTabBarTitleColor {
    for (int i=0;i<[self.tabDataSource numberOfTab];i++) {
        MYZPageTagTitleView *titleView = (MYZPageTagTitleView *)self.tagViewsCache[i];
        if ([self.tabDataSource respondsToSelector:@selector(titleColorForIndex:)]) {
            titleView.normalTitleColor = [self.tabDataSource titleColorForIndex:i];
        }
        if ([self.tabDataSource respondsToSelector:@selector(titleHighlightColorForIndex:)]) {
            titleView.highlightedTitleColor = [self.tabDataSource titleHighlightColorForIndex:i];
        }
    }
}



@end
