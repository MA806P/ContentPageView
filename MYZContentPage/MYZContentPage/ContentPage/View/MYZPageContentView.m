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
        //self.backgroundColor = [UIColor redColor];
        self.scrollsToTop = NO;
        
#ifdef __IPHONE_11_0
        // ios11 苹果加了一个安全区域 会自动修改scrollView的contentOffset
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


- (CGRect)getVisibleViewControllerFrameWithIndex:(NSInteger)index {
    CGFloat offsetX = index * self.frame.size.width;
    return CGRectMake(offsetX, 0, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)getOffsetWithIndex:(NSInteger)index {
    CGFloat width = self.frame.size.width;
    CGFloat maxWidth = self.contentSize.width;
    
    CGFloat offseX = index * width;
    
    if (offseX < 0) {
        offseX = 0;
    }
    
    if (maxWidth > 0.0 && offseX > maxWidth - width) {
        offseX = maxWidth - width;
    }
    
    return CGPointMake(offseX, 0);
}

- (NSInteger)getIndex {
    NSInteger startIndex = (NSInteger)(self.contentOffset.x/self.frame.size.width);
    if (startIndex < 0) {
        startIndex = 0;
    }
    return startIndex;
}

- (void)setItem:(id<MYZPageDateSource>)item {
    NSInteger startIndex = -1;
    NSInteger endIndex = -1;
    
    for (NSInteger i=0; i<[item numberOfControllers]; i++) {
        
        if (startIndex == -1
            && [item respondsToSelector:@selector(isSubPageCanScrollForIndex:)]
            && [item isSubPageCanScrollForIndex:i] ) {
            startIndex = i;
        }
        
        if (startIndex >= 0) {
            if (! ([item respondsToSelector:@selector(isSubPageCanScrollForIndex:)] && [item isSubPageCanScrollForIndex:i])) {
                endIndex = i;
                break;
            }
        }
    }
    
    if (startIndex >= 0 && endIndex == -1) {
        endIndex = [item numberOfControllers];
    }
    
    self.contentInset = UIEdgeInsetsMake(0, -(startIndex)*self.frame.size.width, 0, 0);
    self.contentSize = CGSizeMake((endIndex)*self.frame.size.width, self.frame.size.height);
}




@end
