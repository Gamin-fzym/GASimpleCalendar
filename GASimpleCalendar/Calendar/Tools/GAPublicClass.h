//
//  GAPublicClass.h
//  GASimpleCalendar
//
//  Created by Gamin on 9/14/20.
//  Copyright © 2020 Gamin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GAPublicClass : NSObject

/// 获得日期组件 
+ (NSDateComponents *)getDateComponentsWithDate:(NSDate *)theDate;

/// 根据传入的格式获取当前时间  yyyy-MM-dd HH:mm
+ (NSString *)getNowTimeWithFormat:(NSString *)format;

/// 获取NSDate 根据传入的固定格式的字符串 yyyy|yyyy-MM|yyyy-MM-dd|yyyy-MM-dd HH:mm
+ (NSDate *)getDateWithStringTime:(NSString *)str andFomatter:(NSString *)fomatter;

/// 获取日期对应的某个月的天数
+ (NSInteger)getDaysInMonthWithDate:(NSDate *)theDate;

/**
 根据date获取当期月、或之前第几月、或之后第一月的date
 month >  0 获取date之后的日期
 month <  0 获取date之前的日期
 比如：获取前三个月的时间
 NSDate *monthagoData = [GlobelConfig getPriousorLaterDateFromDate: [NSDate date] withMonth:-3];
 */
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

@end

NS_ASSUME_NONNULL_END
