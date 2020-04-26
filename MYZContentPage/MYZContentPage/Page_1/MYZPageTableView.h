//
//  MYZPageTableView.h
//  MYZPage
//
//  Created by MA806P on 2020/4/23.
//  Copyright © 2020 myz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYZPageTableView;

@protocol MYZPageTableViewDelegate <NSObject>

- (void)pageTableView:(MYZPageTableView *)tableView verticalScrollPosition:(CGFloat)position;

@end


@interface MYZPageTableView : UIView

@property (nonatomic, weak) id<MYZPageTableViewDelegate> delegate;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isShow;

@end

NS_ASSUME_NONNULL_END
