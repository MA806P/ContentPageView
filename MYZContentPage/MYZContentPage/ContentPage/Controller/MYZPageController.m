//
//  MYZPageController.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZPageController.h"
#import "MYZPageContentView.h"

@interface MYZPageController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIViewController *> *menoryCacheDic;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *lastContentOffsetDic;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *lastContentSizeDic;

@property (nonatomic, strong) MYZPageContentView *scrollView;

@property (nonatomic, assign) NSInteger currentPageIndex;

@end

@implementation MYZPageController

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        self.menoryCacheDic = [[NSMutableDictionary<NSNumber *, UIViewController *> alloc] init];
        self.lastContentOffsetDic = [[NSMutableDictionary <NSNumber *, NSNumber *> alloc] init];
        self.lastContentSizeDic = [[NSMutableDictionary <NSNumber *, NSNumber *> alloc] init];
    }
    return self;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self p_controllerAtIndex:0] beginAppearanceTransition:NO animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self p_controllerAtIndex:0] endAppearanceTransition];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    
    //content scroll view
    self.scrollView = [[MYZPageContentView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
}



#pragma mark - private method

//add child controller, add subview to scroll view
- (void)p_addVisibleViewController:(UIViewController *)childController index:(NSInteger)index {
    
    if (![self.childViewControllers containsObject:childController]) {
        [self addChildViewController:childController];
        [childController didMoveToParentViewController:self];
    }
    //[super addChildViewController:childController];
    
    CGRect childViewFrame = [self.scrollView getVisibleViewControllerFrameWithIndex:index];
    childController.view.frame = childViewFrame;
    [self.scrollView addSubview:childController.view];
}

//get controller from dataSource, add controller view, cache controller
- (UIViewController *)p_controllerAtIndex:(NSInteger)index {
    
    if (![self.menoryCacheDic objectForKey:@(index)]) {
        
        UIViewController *controller = [self.dataSource controllerAtIndex:index];
        if (controller) {
            
            if ([self.dataSource respondsToSelector:@selector(isSubPageCanScrollForIndex:)]
                && [self.dataSource isSubPageCanScrollForIndex:index]) {
                controller.view.hidden = YES;
            } else {
                controller.view.hidden = NO;
            }
            
            if ([controller conformsToProtocol:@protocol(MYZPageSubControllerDataSource)]) {
                
            }
            
            [self.menoryCacheDic setObject:controller forKey:@(index)];
            [self p_addVisibleViewController:controller index:index];
        }
    }
    return self.menoryCacheDic[@(index)];
}


- (void)p_bindController:(UIViewController<MYZPageSubControllerDataSource> *)controller index:(NSInteger)index {
    
    UIScrollView *scrollView = [controller preferScrollView];
    scrollView.scrollsToTop = NO;
    scrollView.tag = index;
    
    if ([self.dataSource respondsToSelector:@selector(pageTopAtIndex:)]) {
        UIEdgeInsets contentInset = scrollView.contentInset;
        scrollView.contentInset = UIEdgeInsetsMake([self.dataSource pageTopAtIndex:index], contentInset.left, contentInset.bottom, contentInset.right);
        
#ifdef __IPHONE_11_0
        // ios11 苹果加了一个安全区域 会自动修改scrollView的contentOffset
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
    }
    
    //观察page里面显示的childController的scrollView，纵向滑动的控制
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    scrollView.contentOffset = CGPointMake(0, -scrollView.contentInset.top);
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        UIScrollView *scrollView = object;
        NSInteger index = scrollView.tag;
        
        if (scrollView.tag != self.currentPageIndex) {
            return;
        }
        
        if (self.menoryCacheDic.count == 0) {
            return;
        }
        
        //childController的scrollView，控制纵向滑动
        //判断scrollView能否上下滑动
        BOOL isNotNeedChangeContentOffset = scrollView.contentSize.height < KMYZ_SCREEN_HEIGHT - KMYZ_NAVSTATUSBAR_HEIGHT && fabs(self.lastContentSizeDic[@(index)].floatValue - scrollView.contentSize.height) > 1.0;
        
        if (self.delegate.cannotScrollWithPageOffset || isNotNeedChangeContentOffset) {
            if (self.lastContentOffsetDic[@(index)] && fabs(self.lastContentOffsetDic[@(index)].floatValue - scrollView.contentOffset.y) > 0.1) {
                scrollView.contentOffset = CGPointMake(0, self.lastContentOffsetDic[@(index)].floatValue);
            }
        } else {
            
        }
        
    }
    
}



+ (BOOL)iPhoneX {
    static BOOL flag;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        flag = CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size);
    });
    return flag;
}


@end
