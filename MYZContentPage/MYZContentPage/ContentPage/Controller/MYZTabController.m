//
//  MYZTabController.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZTabController.h"
#import "MYZPageController.h"
#import "MYZTagBarScrollView.h"

@interface MYZTabController ()

@property (nonatomic, strong) MYZPageController *pageController;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, assign) BOOL cannotScrollWithPageOffset;

@end

@implementation MYZTabController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.cannotScrollWithPageOffset = NO;
    //    [self.pageController beginAppearanceTransition:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.cannotScrollWithPageOffset = YES;
    //    [self.pageController beginAppearanceTransition:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.maxYPullDown = [UIScreen mainScreen].bounds.size.height;
    self.minYPullUp = 64;
    
    
    MYZPageController *pageController = [[MYZPageController alloc] init];
    pageController.dataSource = self;
    pageController.delegate = self;
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
    self.pageController = pageController;
    
    
    if ([self preferSingleTabNotShow] == NO || [self numberOfControllers] > 1) {
        UIView *tagView = [self customTabView];
        if (tagView == nil) {
            tagView = [[MYZTagBarScrollView alloc] initWithFrame:[self preferTabFrame] dataSource:self delegate:self];
        }
        [self.view addSubview:tagView];
        self.tagView = tagView;
    }
}



- (CGRect)preferTabFrame {
    return CGRectMake([self preferTabX], [self preferTabY], [self preferTabW], [self preferTabHAtIndex:self.pageController.currentPageIndex]);
}




#pragma mark - public method

//单一tab 是否需要展示
- (BOOL)preferSingleTabNotShow {
    return NO;
}

//自定义TABView,最好遵循TabDelegate，TabDataSource,要不有些情况要重写
- (UIView *)customTabView {
    return nil;
}

//适用于Tab高度 变化的情况
- (void)reloadTabH:(BOOL)isTabScroll {
    
}

//需要完全刷新页面时调用这个接口
- (void)reloadData {
    
}



#pragma mark - private method

- (void)tabDragWithOffset:(CGFloat)offset {
    [self setTabViewTop:[self tabScrollTopWithContentOffset:offset]];
}

- (CGFloat)tabScrollTopWithContentOffset:(CGFloat)offset {
    CGFloat top = [self preferTabY]-offset;
    if (offset >= 0) {//上滑
        if (top <= self.minYPullUp) {
            top = self.minYPullUp;
        }
    } else {//下拉
        if (top >= self.maxYPullDown) {
            top = self.maxYPullDown;
        }
    }
    return top;
}

- (void)setTabViewTop:(CGFloat)tabViewTop {
    self.tagView.frame = CGRectMake(self.tagView.frame.origin.x, tabViewTop, self.tagView.frame.size.width, self.tagView.frame.size.height);
}

- (void)updateTabBarWithIndex:(NSInteger)index
{
    if ([self.tagView isKindOfClass:[MYZTagBarScrollView class]]) {
        MYZTagBarScrollView *tabView = (MYZTagBarScrollView *)self.tagView;
        [tabView reloadHighlightToIndex:index];
    }
    
}

#pragma mark - MYZPageDelegate

- (void)scrollViewContentOffsetWithRatio:(CGFloat)ratio draging:(BOOL)draging {
    if ([self.tagView isKindOfClass:[MYZTagBarScrollView class]]) {
        if (!draging) {
            __weak typeof(self) wSelf = self;
            [UIView animateWithDuration:0.3 animations:^{
                MYZTabController *bSelf = wSelf;
                MYZTagBarScrollView *scrollView = (MYZTagBarScrollView *)bSelf.tagView;
                [scrollView markViewScrollToIndex:ratio];
                scrollView.markViewScroll = NO;
            } completion:^(BOOL finished) {
                MYZTabController *bSelf = wSelf;
                MYZTagBarScrollView *scrollView = (MYZTagBarScrollView *)bSelf.tagView;
                scrollView.markViewScroll = YES;
                [self updateTabBarWithIndex:floor(ratio+0.5)];
            }];
        }
    } else {
        MYZTagBarScrollView *scrollView = (MYZTagBarScrollView *)self.tagView;
        [scrollView markViewScrollToContentRatio:ratio];
        [self updateTabBarWithIndex:floor(ratio+0.5)];
    }
    
}


- (void)scrollWithPageOffset:(CGFloat)realOffset index:(NSInteger)index {
    [self tabDragWithOffset:realOffset + [self pageTopAtIndex:index]];
}


#pragma mark -  MYZPageDataSource

- (NSInteger)numberOfControllers {
    return 0;
}

- (CGRect)preferPageFrame {
    return CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}


- (UIViewController *)controllerAtIndex:(NSInteger)index {
    //NSLog(@" %s ", __func__);
    return nil;
}

- (CGFloat)pageTopAtIndex:(NSInteger)index {
    return [self preferTabY] + [self preferTabHAtIndex:index]-[self preferPageFrame].origin.y;
}


#pragma mark - MYZTabDataSource

- (CGFloat)preferTabX {
    return 0;
}

- (CGFloat)preferTabY {
    return 64;
}

- (CGFloat)preferTabW {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)preferTabHAtIndex:(NSInteger)index {
    return 40;
}

- (NSInteger)preferPageFirstAtIndex {
    return 0;
}

- (NSString *)titleForIndex:(NSInteger)index {
    return nil;
}

- (NSInteger)numberOfTab {
    return [self numberOfControllers];
}

-(CGFloat)tabTopForIndex:(NSInteger)index {
    return 0;
}

- (CGFloat)tabWidthForIndex:(NSInteger)index {
    NSString *text = [self titleForIndex:index];
    if (text.length <=3) {
        return 73;
    } else {
        return 105;
    }
}

- (UIColor *)titleColorForIndex:(NSInteger)index {
    return [UIColor blackColor];
}

- (UIColor *)titleHighlightColorForIndex:(NSInteger)index {
    return [UIColor orangeColor];
}

- (UIFont *)titleFontForIndex:(NSInteger)index {
    return [UIFont systemFontOfSize:13.0];
}

- (UIColor *)tabBackgroundColor {
    return [UIColor whiteColor];
}

- (NSInteger)preferTabIndex{
    return [self preferPageFirstAtIndex];
}

- (BOOL)needMarkView {
    return YES;
}

- (CGFloat)markViewBottom {
    return [self preferTabHAtIndex:self.pageController.currentPageIndex]-7;
}

-(CGFloat)markViewWidthForIndex:(NSInteger)index
{
    NSString *text = [self titleForIndex:index];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(20000, 40) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self titleFontForIndex:index ]} context:nil];
    
    return rect.size.width;
}

-(UIColor *)markViewColorForIndex:(NSInteger)index
{
    return [UIColor orangeColor];
}

@end



