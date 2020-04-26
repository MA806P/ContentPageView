//
//  MYZPageTableView.m
//  MYZPage
//
//  Created by MA806P on 2020/4/23.
//  Copyright © 2020 myz. All rights reserved.
//

#import "MYZPageTableView.h"

@interface MYZPageTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MYZPageTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        //列表视图
        self.dataArray = [NSMutableArray array];
        for (int i = 0; i < 200; i++) {
            [self.dataArray addObject:@""];
        }
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0.0;
        tableView.estimatedSectionFooterHeight = 0.0;
        tableView.estimatedSectionHeaderHeight = 0.0;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial;
        [tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
        [tableView reloadData];
    }
    return self;
}

#pragma mark - table view scroll action

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if (self.delegate == nil) { return; }
    
    UITableView * tableView = (UITableView *)object;
    if (tableView != self.tableView || self.isShow == NO ) { return; }
    
    CGPoint tableOffset = tableView.contentOffset;
    CGFloat currentY = tableOffset.y;
    
    if ([self.delegate respondsToSelector:@selector(pageTableView:verticalScrollPosition:)]) {
        [self.delegate pageTableView:self verticalScrollPosition:currentY];
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - UITableView delegate data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYZPageTestCellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MYZPageTestCellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"index = %ld", indexPath.row];
    return cell;
}

@end

