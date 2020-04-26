//
//  MYZPageViewController.m
//  MYZContentPage
//
//  Created by MA806P on 2020/4/25.
//  Copyright © 2020 myz. All rights reserved.
//

#import "MYZPageViewController.h"

@interface MYZPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *vcs;

@end

@implementation MYZPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(nextPushAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    
    
    // UIPageViewController 配置项
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    UIPageViewController *pageVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                 options:options];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor purpleColor];
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor cyanColor];
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor lightGrayColor];
    self.vcs = @[vc1, vc2, vc3];
    
    
    // Set visible view controllers, optionally with animation. Array should only include view controllers that will be visible after the animation has completed.
    // For transition style 'UIPageViewControllerTransitionStylePageCurl', if 'doubleSided' is 'YES' and the spine location is not 'UIPageViewControllerSpineLocationMid', two view controllers must be included, as the latter view controller is used as the back.
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意 viewControllers至少包含两个数据,且 doubleSided = YES
    [pageVc setViewControllers:@[vc1] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        NSLog(@"set vc completion");
    }];
    
    
    pageVc.delegate = self;
    pageVc.dataSource = self;
    
    [self addChildViewController:pageVc];
    [self.view addSubview:pageVc.view];
    [pageVc didMoveToParentViewController:self];
}


- (void)nextPushAction:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -

//返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.vcs indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return self.vcs[index];
}

//返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.vcs indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index >= [self.vcs count]) {
        return nil;
    }
    return self.vcs[index];
}


@end
