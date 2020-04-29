//
//  MYZContentItemController.m
//  MYZContentPage
//
//  Created by MA806P on 2020/4/26.
//  Copyright © 2020 myz. All rights reserved.
//

#import "MYZContentItemController.h"
#import "MYZItemCell.h"
#import "MYZConst.h"

@interface MYZContentItemController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MYZItemCellDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, weak) UIView *snapshotView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation MYZContentItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(navBarRightButtonAction)];
    self.status = 1;
    
    CGFloat collectionY = IPHONE_NAVIGATIONBAR_HEIGHT;
    CGFloat collectionH = SCREEN_HEIGHT - collectionY;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH * 0.25,60);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionY, SCREEN_WIDTH, collectionH) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[MYZItemCell class] forCellWithReuseIdentifier:@"MYZItemCellId"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView reloadData];
    
}


//编辑按钮点击
- (void)navBarRightButtonAction {
    /*
    if (self.status == 0) {
        self.status = 1;
        self.navigationItem.rightBarButtonItem.title = @"完成";
    } else {
        self.status = 0;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    [self.collectionView reloadData];
     */
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - MYZItemCellDelegate


//删除或添加处理，同时修改数据
- (void)itemCell:(MYZItemCell *)cell titleEditBtnTouchActionWithTitle:(NSString *)title {
     NSIndexPath *nowIndexPath = [self.collectionView indexPathForCell:cell];
    NSIndexPath *nextIndexPath = nil;
    if ([self.myTitleArray containsObject:title] && [self.allTitleArray containsObject:title]==NO) {
        [self.myTitleArray removeObject:title];
        [self.allTitleArray addObject:title];
        nextIndexPath = [NSIndexPath indexPathForRow:self.allTitleArray.count - 1 inSection:1];
    } else if ([self.myTitleArray containsObject:title]==NO && [self.allTitleArray containsObject:title]) {
        [self.myTitleArray addObject:title];
        [self.allTitleArray removeObject:title];
        nextIndexPath = [NSIndexPath indexPathForRow:self.myTitleArray.count - 1 inSection:0];
    }
    [self.collectionView moveItemAtIndexPath:nowIndexPath toIndexPath:nextIndexPath];
}


//长按拖动手势处理
- (void)itemCellDragWithGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint location = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
        if (indexPath == nil || indexPath.section != 0) { return; }
        self.currentIndexPath = indexPath;
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        NSLog(@"begain -- %ld-%ld", indexPath.section, indexPath.row);
        
        self.currentIndexPath = [self.collectionView indexPathForCell:cell];
        //截图
        self.snapshotView = [cell snapshotViewAfterScreenUpdates:YES];
        self.snapshotView.transform = CGAffineTransformMakeScale(1.2, 1.2);//放大
        self.snapshotView.center = cell.center;
        [self.collectionView addSubview:self.snapshotView];
        cell.hidden = YES; //隐藏cell
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint movePoint = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:movePoint];
        self.snapshotView.center = movePoint;
        NSLog(@"move -- %@", NSStringFromCGPoint(movePoint));
        
        if ( indexPath != nil && indexPath.section == self.currentIndexPath.section && indexPath.section == 0) {
            //移动数据
            NSString *data = self.myTitleArray[self.currentIndexPath.row];
            [self.myTitleArray removeObject:data];
            [self.myTitleArray insertObject:data atIndex:indexPath.row];
            
            //移动 cell
            [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
            self.currentIndexPath = indexPath;
        }
        
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.snapshotView == nil) { return; }
        UICollectionViewCell *tempCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
        NSLog(@"end -- %ld-%ld", self.currentIndexPath.section, self.currentIndexPath.row);
        
        //手势结束后，把截图隐藏，显示出原先的cell
        [UIView animateWithDuration:0.25 animations:^{
            self.snapshotView.center = tempCell.center;
        } completion:^(BOOL finished) {
            [self.snapshotView removeFromSuperview];
            tempCell.hidden = NO;
            self.snapshotView = nil;
            self.currentIndexPath = nil;
            [self.collectionView reloadData];
        }];
        
    }
         
}


#pragma mark - UICollectionView delegate data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
        count = self.myTitleArray.count;
    } else if (section == 1) {
        count = self.allTitleArray.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MYZItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MYZItemCellId" forIndexPath:indexPath];
    cell.delegate = self;
    NSInteger status = self.status;
    if (indexPath.section == 0) {
        cell.titleText = self.myTitleArray[indexPath.item];
        status = status == 0 ? -1 : 1;
    } else if (indexPath.section == 1) {
        cell.titleText = self.allTitleArray[indexPath.item];
        status = status == 0 ? -2 : 2;
    }
    cell.status = status;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 30);
}


@end
