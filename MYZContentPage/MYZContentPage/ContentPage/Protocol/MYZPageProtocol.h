//
//  MYZPageProtocol.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MYZPageDelegate <NSObject>



@end


@protocol MYZPageDateSource <NSObject>

- (UIViewController *)controllerAtIndex:(NSInteger)index;

@end
