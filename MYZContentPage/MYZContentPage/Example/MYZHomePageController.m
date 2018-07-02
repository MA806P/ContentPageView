//
//  MYZHomePageController.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/26.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZHomePageController.h"

@interface MYZHomePageController ()

@end

@implementation MYZHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - PageDataSource

- (UIViewController *)controllerAtIndex:(NSInteger)index {
    
    NSLog(@" %s  %ld", __func__, index);
    
    UIViewController *vc = [[UIViewController alloc] init];
    if (index == 0) {
        vc.view.backgroundColor = [UIColor blueColor];
    } else if (index == 1) {
        vc.view.backgroundColor = [UIColor grayColor];
    } else if (index == 2) {
        vc.view.backgroundColor = [UIColor lightGrayColor];
    }
    return vc;
    
}


- (NSInteger)numberOfControllers {
    return 3;
}

-(BOOL)isSubPageCanScrollForIndex:(NSInteger)index {
    return YES;
}


@end
