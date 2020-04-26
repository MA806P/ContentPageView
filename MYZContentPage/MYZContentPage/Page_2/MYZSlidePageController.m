//
//  MYZSlidePageController.m
//  MYZContentPage
//
//  Created by MA806P on 2020/4/25.
//  Copyright © 2020 myz. All rights reserved.
//

#import "MYZSlidePageController.h"
#import "MYZPageTableView.h"
#import "MYZConst.h"

static CGFloat const MYZSlidePageSegmentViewH = 40.0;

@interface MYZSlidePageController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView * pageSegmentView;
@property (nonatomic, weak) UIScrollView * pageTableScrollView;
@property (nonatomic, weak) UIScrollView *segmentScrollView;
@property (nonatomic, weak) MYZPageTableView *currentTableView;
@property (nonatomic, weak) UIView * indexLine;

@property (nonatomic, strong) NSArray *segmentTitleArray;
@property (nonatomic, strong) NSMutableArray *segmentBtnArray;
@property (nonatomic, strong) NSMutableArray *contentTableArray;

@end

@implementation MYZSlidePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //上部分类
    UIView *pageSegmentView = [self p_createSegmentView];
    [self.view addSubview:pageSegmentView];
    self.pageSegmentView = pageSegmentView;
    
    
    //下部
    UIScrollView * pageTableScrollView = [self p_createTableView];
    [self.view addSubview:pageTableScrollView];
    self.pageTableScrollView = pageTableScrollView;
    
    
    
    //设置显示的数据
    self.segmentBtnArray = [NSMutableArray array];
    self.contentTableArray = [NSMutableArray array];
    self.segmentTitleArray = @[@"Title1",@"Title2",@"Title3",@"Title4",@"Title5",@"Title6",@"Title7",@"Title8",@"Title9"];
    
}



- (void)setSegmentTitleArray:(NSArray *)segmentTitleArray {
    _segmentTitleArray = segmentTitleArray;
    
    for (UIButton *segmentBtn in self.segmentBtnArray) {
        [segmentBtn removeFromSuperview];
    }
    [self.segmentBtnArray removeAllObjects];
    self.indexLine.hidden = NO;
    
    for (MYZPageTableView *tableView in self.contentTableArray) {
        [tableView removeFromSuperview];
    }
    [self.contentTableArray removeAllObjects];
    
    CGFloat typeBtnX = 0, typeBtnW = 80, tableX = 0;
    for (int i = 0; i < self.segmentTitleArray.count; i++) {
        typeBtnX = i * typeBtnW;
        UIButton * typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(typeBtnX, 0, typeBtnW, MYZSlidePageSegmentViewH)];
        [typeBtn setTitle:self.segmentTitleArray[i] forState:UIControlStateNormal];
        typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        typeBtn.tag = i;
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [typeBtn addTarget:self action:@selector(p_segmentBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.segmentScrollView addSubview:typeBtn];
        [self.segmentBtnArray addObject:typeBtn];
        
        tableX = i * SCREEN_WIDTH;
        MYZPageTableView *table = [[MYZPageTableView alloc] initWithFrame:CGRectMake(tableX, 0, SCREEN_WIDTH, self.pageTableScrollView.frame.size.height)];
        [self.pageTableScrollView addSubview:table];
        [self.contentTableArray addObject:table];
        
        if (i == 0) {
            typeBtn.selected = YES;
            table.isShow = YES;
            self.currentTableView = table;
        }
    }
    self.segmentScrollView.contentSize = CGSizeMake(typeBtnX + typeBtnW, MYZSlidePageSegmentViewH);
    self.pageTableScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.segmentTitleArray.count, self.pageTableScrollView.frame.size.height);
    self.pageTableScrollView.contentOffset = CGPointZero;
}


#pragma mark - Methods

//点击分类按钮
- (void)p_segmentBtnTouchAction:(UIButton *)btn {
    if (btn.isSelected) { return; }
    //setContentOffset 会调用 scrollViewDidScroll，在这里设置btn.selected
    NSInteger btnIndex = btn.tag;
    [UIView animateWithDuration:0.2 animations:^{
        self.pageTableScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * btnIndex, 0);
    }];
}

#pragma mark - UIScrollViewDelegate


//左右滑动处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.pageTableScrollView) { return; }
    
    NSInteger index = (NSInteger)scrollView.contentOffset.x/SCREEN_WIDTH;
    if (index < 0 || index >= self.contentTableArray.count) { return; }
    
    self.currentTableView.isShow = NO;
    self.currentTableView = self.contentTableArray[index];
    self.currentTableView.isShow = YES;
    
    UIButton * selectedBtn = self.segmentBtnArray[index];
    if (selectedBtn.isSelected == NO) {
        for (UIButton * btn in self.segmentBtnArray) {
            btn.selected = NO;
        }
        selectedBtn.selected = YES;
    }
    
    CGFloat segementW = self.segmentScrollView.frame.size.width;
    CGFloat moveOffsetX = selectedBtn.frame.origin.x - selectedBtn.frame.size.width * 2.0;
    if (moveOffsetX  > 0) {
        if (moveOffsetX + segementW > self.segmentScrollView.contentSize.width) {
            [self.segmentScrollView setContentOffset:CGPointMake(self.segmentScrollView.contentSize.width - segementW, 0) animated:YES];
        } else {
            [self.segmentScrollView setContentOffset:CGPointMake(moveOffsetX, 0) animated:YES];
        }
    } else {
        [self.segmentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    CGRect indexLineFrame = self.indexLine.frame;
    indexLineFrame.origin.x = selectedBtn.frame.size.width * (scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.indexLine.frame = indexLineFrame;
    
}

#pragma mark - UI


//上部分类视图
- (UIView *)p_createSegmentView {
    UIView *pageSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, MYZSlidePageSegmentViewH)];
    pageSegmentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIScrollView *segmentScrollView = [[UIScrollView alloc] initWithFrame:pageSegmentView.bounds];
    segmentScrollView.showsHorizontalScrollIndicator = NO;
    [pageSegmentView addSubview:segmentScrollView];
    self.segmentScrollView = segmentScrollView;
    
    CGFloat indexLineH = 3.0;
    CGFloat indexLineY = segmentScrollView.frame.size.height - indexLineH;
    UIView *indexLine = [[UIView alloc] initWithFrame:CGRectMake(0, indexLineY, 80, indexLineH)];
    indexLine.backgroundColor = [UIColor blueColor];
    indexLine.hidden = YES;
    [segmentScrollView addSubview:indexLine];
    self.indexLine = indexLine;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, MYZSlidePageSegmentViewH - 1.0, SCREEN_WIDTH, 1.0)];
    line.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    [pageSegmentView addSubview:line];
    
    return pageSegmentView;
}

//下部列表视图
- (UIScrollView *)p_createTableView {
    CGFloat tableViewY = IPHONE_NAVIGATIONBAR_HEIGHT + MYZSlidePageSegmentViewH;
    CGFloat tableViewH = SCREEN_HEIGHT - tableViewY - IPHONE_TABBAR_HEIGHT;
    UIScrollView * pageTableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tableViewY, SCREEN_WIDTH, tableViewH)];
    pageTableScrollView.delegate = self;
    pageTableScrollView.pagingEnabled = YES;
    pageTableScrollView.showsHorizontalScrollIndicator = NO;
    return pageTableScrollView;
}


@end

