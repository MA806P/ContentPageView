//
//  MYZPageContentView.m
//  MYZContentPage
//
//  Created by MA806P on 2018/6/28.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZPageContentView.h"

@implementation MYZPageContentView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = (0x1<<6) - 1;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor grayColor];
        self.scrollsToTop = NO;
        
#ifdef __IPHONE_11_0
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    if (![self.subviews containsObject:view]) {
        [super addSubview:view];
    }
}





@end
