//
//  Test1ViewController.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/26.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface Test1ViewController ()

@property (nonatomic, strong) Test2ViewController *vc;

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    Test2ViewController *vc = [[Test2ViewController alloc] init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    self.vc = vc;
}

- (void)nextAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@" %s ", __func__);
    
    [self.vc beginAppearanceTransition:NO animated:YES];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@" %s ", __func__);
    
    [self.vc endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@" %s ", __func__);
    
    [self.vc beginAppearanceTransition:NO animated:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@" %s ", __func__);
    
    [self.vc endAppearanceTransition];
}



@end
