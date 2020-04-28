//
//  MYZItemCell.h
//  MYZContentPage
//
//  Created by MA806P on 2020/4/27.
//  Copyright © 2020 myz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYZItemCell;

@protocol MYZItemCellDelegate <NSObject>

- (void)itemCellDragWithGestureAction:(UIGestureRecognizer *)gestureRecognizer;
- (void)itemCell:(MYZItemCell *)cell titleEditBtnTouchActionWithTitle:(NSString *)title;

@end

@interface MYZItemCell : UICollectionViewCell

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, weak) id<MYZItemCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
