//
//  MYZPageController.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZPageController.h"


@interface MYZPageController ()

@end

@implementation MYZPageController

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
    // Do any additional setup after loading the view.
}



- (UIViewController *)p_controllerAtIndex:(NSInteger)index {
    
    UIViewController *vc = [self.dataSource controllerAtIndex:index];
    [self p_addChildViewController:vc];
    return vc;
}

- (void)p_addChildViewController:(UIViewController *)childController {
    if (![self.childViewControllers containsObject:childController]) {
        [self addChildViewController:childController];
        [self.view addSubview:childController.view];
        [childController didMoveToParentViewController:self];
    }
    [super addChildViewController:childController];
}




@end
