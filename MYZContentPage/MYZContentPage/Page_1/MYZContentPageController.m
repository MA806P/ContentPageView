//
//  MYZContentPageController.m
//  MYZContentPage
//
//  Created by MA806P on 2020/4/25.
//  Copyright © 2020 myz. All rights reserved.
//

#import "MYZContentPageController.h"
#import "MYZPageTableView.h"
#import "MYZConst.h"
#import "MYZContentItemController.h"

static CGFloat const MYZPageHeadViewH = 170.0;
static CGFloat const MYZPageSegmentViewH = 40.0;

@interface MYZContentPageController ()<UIScrollViewDelegate, MYZPageTableViewDelegate>

@property (nonatomic, weak) UIView * pageHeadView;
@property (nonatomic, weak) UIView * pageSegmentView;
@property (nonatomic, weak) UIScrollView * pageTableScrollView;
@property (nonatomic, weak) UIScrollView *segmentScrollView;
@property (nonatomic, weak) MYZPageTableView *currentTableView;
@property (nonatomic, weak) UIView * indexLine;

@property (nonatomic, strong) NSMutableArray *allSegmentTitleArray;
@property (nonatomic, strong) NSMutableArray *segmentTitleArray;
@property (nonatomic, strong) NSMutableArray *segmentBtnArray;
@property (nonatomic, strong) NSMutableArray *contentTableArray;

@end

@implementation MYZContentPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //头部
    UIView *pageHeadView = [self p_createHeadView];
    [self.view addSubview:pageHeadView];
    self.pageHeadView = pageHeadView;
    
    //中间
    UIView *pageSegmentView = [self p_createSegmentView];
    [self.view addSubview:pageSegmentView];
    self.pageSegmentView = pageSegmentView;
    
    
    //下部
    UIScrollView * pageTableScrollView = [self p_createTableView];
    [self.view insertSubview:pageTableScrollView atIndex:0];
    self.pageTableScrollView = pageTableScrollView;
    
    //设置显示的数据
    self.segmentBtnArray = [NSMutableArray array];
    self.contentTableArray = [NSMutableArray array];

    self.allSegmentTitleArray = [NSMutableArray arrayWithArray:@[@"Title4",@"Title5",@"Title6",@"Title7",@"Title8",@"Title9"]];
    self.segmentTitleArray = [NSMutableArray arrayWithArray:@[@"Title1",@"Title2",@"Title3"]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pageReloadData];
}


- (void)pageReloadData {
    
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
        UIButton * typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(typeBtnX, 0, typeBtnW, MYZPageSegmentViewH)];
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
        table.tableView.contentInset = UIEdgeInsetsMake(MYZPageHeadViewH, 0, 0, 0);
        table.tableView.contentOffset = CGPointMake(0, -MYZPageHeadViewH);
        table.delegate = self;
        [self.pageTableScrollView addSubview:table];
        [self.contentTableArray addObject:table];
        
        if (i == 0) {
            typeBtn.selected = YES;
            table.isShow = YES;
            self.currentTableView = table;
        }
    }
    self.segmentScrollView.contentSize = CGSizeMake(typeBtnX + typeBtnW, MYZPageSegmentViewH);
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

//更多按钮点击
- (void)p_moreBtnTouchAction {
    MYZContentItemController *item = [[MYZContentItemController alloc] init];
    item.allTitleArray = self.allSegmentTitleArray;
    item.myTitleArray = self.segmentTitleArray;
    [self.navigationController pushViewController:item animated:YES];
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

#pragma mark - MYZPageTableViewDelegate

//上下滑动
- (void)pageTableView:(MYZPageTableView *)tableView verticalScrollPosition:(CGFloat)position {
    
    CGFloat currentY = position + MYZPageHeadViewH;
    //NSLog(@"=== %.2lf", currentY);
    if (currentY >= 0) {
        
        if (currentY < MYZPageHeadViewH) {
            self.pageHeadView.frame = CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT - currentY, self.pageHeadView.frame.size.width, self.pageHeadView.frame.size.height);
            self.pageSegmentView.frame = CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT + self.pageHeadView.frame.size.height - currentY, self.pageSegmentView.frame.size.width, self.pageSegmentView.frame.size.height);
            
            CGPoint scrollOffset = tableView.tableView.contentOffset;
            for (MYZPageTableView *view in self.contentTableArray) {
                if (view != tableView ) {
                    view.tableView.contentOffset = scrollOffset;
                }
            }
        } else {
            self.pageHeadView.frame = CGRectMake(0,  IPHONE_NAVIGATIONBAR_HEIGHT - self.pageHeadView.frame.size.height, self.pageHeadView.frame.size.width, self.pageHeadView.frame.size.height);
            self.pageSegmentView.frame = CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.pageSegmentView.frame.size.width, self.pageSegmentView.frame.size.height);
            
            
            for (MYZPageTableView *view in self.contentTableArray) {
                if (view != tableView && view.tableView.contentOffset.y < 0) {
                    view.tableView.contentOffset = CGPointZero;
                }
            }
        }
        
    } else {
        self.pageHeadView.frame = CGRectMake(0,  IPHONE_NAVIGATIONBAR_HEIGHT - currentY, self.pageHeadView.frame.size.width, self.pageHeadView.frame.size.height);
        self.pageSegmentView.frame = CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT + self.pageHeadView.frame.size.height - currentY, self.pageSegmentView.frame.size.width, self.pageSegmentView.frame.size.height);
    }
}



#pragma mark - UI

//头部视图
- (UIView *)p_createHeadView {
    UIView *pageHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, MYZPageHeadViewH)];
    pageHeadView.backgroundColor = [UIColor purpleColor];
    return pageHeadView;
}

//中间分类视图
- (UIView *)p_createSegmentView {
    UIView *pageSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT + MYZPageHeadViewH, SCREEN_WIDTH, MYZPageSegmentViewH)];
    pageSegmentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    CGFloat btnW = 60;
    CGFloat btnX = SCREEN_WIDTH - btnW;
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, MYZPageSegmentViewH)];
    moreBtn.backgroundColor = [UIColor whiteColor];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(p_moreBtnTouchAction) forControlEvents:UIControlEventTouchUpInside];
    [pageSegmentView addSubview:moreBtn];
    
    
    UIScrollView *segmentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, btnX, MYZPageSegmentViewH)];
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
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, MYZPageSegmentViewH - 1.0, SCREEN_WIDTH, 1.0)];
    line.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.6];
    [pageSegmentView addSubview:line];
    
    return pageSegmentView;
}

//下部列表视图
- (UIScrollView *)p_createTableView {
    CGFloat tableViewY = IPHONE_NAVIGATIONBAR_HEIGHT + MYZPageSegmentViewH;
    CGFloat tableViewH = SCREEN_HEIGHT - tableViewY - IPHONE_TABBAR_HEIGHT;
    UIScrollView * pageTableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, tableViewY, SCREEN_WIDTH, tableViewH)];
    pageTableScrollView.delegate = self;
    pageTableScrollView.pagingEnabled = YES;
    pageTableScrollView.showsHorizontalScrollIndicator = NO;
    return pageTableScrollView;
}


@end

