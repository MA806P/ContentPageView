//
//  MYZTabController.h
//  MYZContentPage
//
//  Created by MA806P on 2018/6/27.
//  Copyright © 2018年 myz. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MYZPageProtocol.h"
#import "MYZTabProtocol.h"

@interface MYZTabController : UIViewController<MYZPageDateSource, MYZPageDelegate, MYZTabDataSource>

@end
