//
//  MCDatePickerView.h
//  MFCDatePackerView
//
//  Created by machao on 2017/5/23.
//  Copyright © 2017年 machao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XMGStyleType) {
    XMGStyleTypeYear = 0,//年
    XMGStyleTypeYearAndMonth,//年月
    XMGStyleTypeYearAndMonthDay,//年月日
};


@protocol MCDatePickerViewDelegate <NSObject>

@optional
- (void)didSelectDateResult:(NSString *)resultDate;

- (void)didSelectDateResult:(NSString *)resultDate ViewTag:(NSInteger)tag;

@end

@interface MCDatePickerView : UIView

@property (nonatomic ,weak) id<MCDatePickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(XMGStyleType)type WithDafultDateStr:(NSString *)defultDateStr;

/**
 显示PickerView
 */
- (void)show;

/**
 移除PickerView
 */
- (void)remove;

@end
