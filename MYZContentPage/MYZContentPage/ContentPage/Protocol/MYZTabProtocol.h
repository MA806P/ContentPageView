//
//  MYZTabProtocol.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYZTabDelegate <NSObject>



@end



@protocol MYZTabDataSource <NSObject>

- (CGFloat)preferTabY;
- (CGFloat)preferTabX;
- (CGFloat)preferTabW;

@end
