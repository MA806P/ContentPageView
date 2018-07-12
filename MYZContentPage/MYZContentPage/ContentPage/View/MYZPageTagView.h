//
//  MYZPageTagView.h
//  MYZContentPage
//
//  Created by MA806P on 2018/7/12.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYZPageTagView : UIControl

@property (assign, nonatomic) NSUInteger tagIndex;
@property (strong, nonatomic) UIColor *highlightedTitleColor;
@property (strong, nonatomic) UIColor *normalTitleColor;
@property (assign, nonatomic, readonly) BOOL isHighlighted;

- (void)highlightTagView;
- (void)unhighlightTagView;

@end


@interface MYZPageTagTitleView : MYZPageTagView

@property (strong, nonatomic) UILabel *title;

@end
