//
//  MYZPageContentView.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/28.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYZPageProtocol.h"



@interface MYZPageContentView : UIScrollView

- (CGRect)getVisibleViewControllerFrameWithIndex:(NSInteger)index;
- (CGPoint)getOffsetWithIndex:(NSInteger)index;
- (NSInteger)getIndex;

- (void)setItem:(id<MYZPageDateSource>)item;


@end
