//
//  MYZPageTagView.m
//  MYZContentPage
//
//  Created by MA806P on 2018/7/12.
//  Copyright © 2018年 myz. All rights reserved.
//

#import "MYZPageTagView.h"

@interface MYZPageTagView ()

@property (assign, nonatomic, readwrite) BOOL isHighlighted;

@end

@implementation MYZPageTagView

- (void)highlightTagView
{
    NSException *exception = [NSException exceptionWithName:@"Method no override Exception" reason:@"Method highlightTagView must be override!" userInfo:nil];
    @throw exception;
}

- (void)unhighlightTagView
{
    NSException *exception = [NSException exceptionWithName:@"Method no override Exception" reason:@"Method unhighlightTagView must be override!" userInfo:nil];
    @throw exception;
}

@end


@implementation MYZPageTagTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.title = [[UILabel alloc] init];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.frame = self.bounds;
        
        [self addSubview:self.title];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title sizeToFit];
    self.title.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}

- (void)highlightTagView {
    self.title.textColor = self.highlightedTitleColor;
    self.isHighlighted = YES;
}

- (void)unhighlightTagView {
    self.title.textColor = self.normalTitleColor ;
    self.isHighlighted = NO;
}



@end
