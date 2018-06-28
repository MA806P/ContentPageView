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
    
    NSLog(@" %s ", __func__);
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor blueColor];
    return vc;
    
}




@end
