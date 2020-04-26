//
//  MYZConst.h
//  MYZContentPage
//
//  Created by MA806P on 2020/4/26.
//  Copyright © 2020 myz. All rights reserved.
//

#ifndef MYZConst_h
#define MYZConst_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IS_IPHONE_X ((SCREEN_HEIGHT/SCREEN_WIDTH) >= 2)
#define IPHONE_NAVIGATIONBAR_HEIGHT  (IS_IPHONE_X ? 88 : 64)
#define IPHONE_TABBAR_HEIGHT         (IS_IPHONE_X ? 83 : 49)

#endif /* MYZConst_h */
