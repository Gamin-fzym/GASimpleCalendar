//
//  BLCalendarViewController.h
//  甲丁
//
//  Created by Gamin on 9/7/20.
//  Copyright © 2020 langdaoTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLCalendarViewController : UIViewController

@property (nonatomic, copy) void (^ChangeShowStatusBlock)(BOOL isShow);
@property (nonatomic, copy) void (^SelectDateBlock)(NSDateComponents *returnTime);

- (NSString *)getFormatTimeString;

- (float)getHeaderHeight;
// 收回View
- (void)takeBackView;

@end

NS_ASSUME_NONNULL_END
