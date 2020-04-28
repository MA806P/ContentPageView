//
//  MYZItemCell.m
//  MYZContentPage
//
//  Created by MA806P on 2020/4/27.
//  Copyright © 2020 myz. All rights reserved.
//

#import "MYZItemCell.h"
#import "MYZConst.h"

@interface MYZItemCell ()

@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UIButton *statusBtn;

@end

@implementation MYZItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat labX = (SCREEN_WIDTH * 0.25 - 60) * 0.5;
        CGFloat labY = (60 - 26)*0.5;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(labX, labY, 60, 36)];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = [UIColor blackColor];
        titleLab.layer.cornerRadius = 6;
        titleLab.layer.borderColor = [[UIColor blackColor] CGColor];
        titleLab.layer.borderWidth = 1.0;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLab];
        self.titleLab = titleLab;
        
        CGFloat btnWH = 20;
        UIButton *statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25 - btnWH, 6, btnWH, btnWH)];
        [statusBtn addTarget:self action:@selector(statusBtnTouchAction) forControlEvents:UIControlEventTouchUpInside];
        statusBtn.hidden = YES;
        [self addSubview:statusBtn];
        self.statusBtn = statusBtn;
        
        
        UILongPressGestureRecognizer * longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
        [self addGestureRecognizer:longPress];
        
        
    }
    return self;
}


//手势按钮响应
- (void)gestureAction:(UIGestureRecognizer *)gesture {
    if (self.status == -1 || self.status == -2) { return; }
    if ([self.delegate respondsToSelector:@selector(itemCellDragWithGestureAction:)]) {
        [self.delegate itemCellDragWithGestureAction:gesture];
    }
}


//删除或添加，同时修改状态
- (void)statusBtnTouchAction {
    if ([self.delegate respondsToSelector:@selector(itemCell:titleEditBtnTouchActionWithTitle:)]) {
        self.status = _status == 1 ? 2 : 1;
        [self.delegate itemCell:self titleEditBtnTouchActionWithTitle:self.titleText];
    }
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLab.text = titleText;
}


- (void)setStatus:(NSInteger)status {
    _status = status;
    
    if (status == -1 || status == -2) {
        self.statusBtn.hidden = YES;
    } else {
        self.statusBtn.hidden = NO;
        if (status == 2) {
            [self.statusBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        } else if (status == 1) {
            [self.statusBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        }
    }
}








@end
