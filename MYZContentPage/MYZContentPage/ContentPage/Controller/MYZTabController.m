//
//  MYZTabController.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZTabController.h"
#import "MYZPageController.h"

@interface MYZTabController ()

@property (nonatomic, strong) MYZPageController *pageController;

@end

@implementation MYZTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYZPageController *pageController = [[MYZPageController alloc] init];
    pageController.dataSource = self;
    pageController.delegate = self;
    
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
    self.pageController = pageController;
}


#pragma mark -  MYZPageDataSource

- (UIViewController *)controllerAtIndex:(NSInteger)index {
    NSLog(@" %s ", __func__);
    return nil;
}

- (NSInteger)numberOfControllers {
    return 0;
}

//- (CGFloat)pageTopAtIndex:(NSInteger)index {
//    
//}



@end



