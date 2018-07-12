//
//  MYZHomePageController.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/26.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZHomePageController.h"
#import "TestHomePageSubController.h"

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
    
    TestHomePageSubController *vc = [[TestHomePageSubController alloc] init];
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


#pragma mark -  TabDataSource

- (NSString *)titleForIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"TAB%zd", index];
}

- (BOOL)needMarkView
{
    return YES;
}

- (CGFloat)preferTabY
{
    return 200;
}


@end
