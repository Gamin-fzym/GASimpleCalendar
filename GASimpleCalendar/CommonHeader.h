//
//  CommonHeader.h
//  GASimpleCalendar
//
//  Created by Gamin on 9/14/20.
//  Copyright © 2020 Gamin. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h
#import "UIColor+HexColor.h"
#import "UIView+AdaptivePerfect.h"

#define HexColor(hexString) [UIColor colorWithHexString:(hexString)]
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE_X (SCREENHEIGHT == 812.0f || SCREENHEIGHT == 896.0f) ? YES : NO
#define HeightNavBar    ((IS_IPHONE_X== YES)?88.0f: 64.0f)
#define NAVBARHEIGHT  ((IS_IPHONE_X== YES)?88.0f: 64.0f)

#endif /* CommonHeader_h */
