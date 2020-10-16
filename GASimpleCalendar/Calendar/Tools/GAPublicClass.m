//
//  GAPublicClass.m
//  GASimpleCalendar
//
//  Created by Gamin on 9/14/20.
//  Copyright © 2020 Gamin. All rights reserved.
//

#import "GAPublicClass.h"

@implementation GAPublicClass

/// 获得日期组件 
+ (NSDateComponents *)getDateComponentsWithDate:(NSDate *)theDate {
    NSDate *nowDate = theDate;
    // 得到年月日，年月日时分秒
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setFirstWeekday:2];
    NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfYear fromDate:nowDate];
    return components;
}

/// 获取当前时间  yyyy-MM-dd HH:mm
+ (NSString *)getNowTimeWithFormat:(NSString *)format {
    NSDate *newDate = [NSDate date];
    long int timeSp = (long)[newDate timeIntervalSince1970];
    // 时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timeSp];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

/// 获取NSDate 根据传入的固定格式的字符串
+ (NSDate *)getDateWithStringTime:(NSString *)str andFomatter:(NSString*)fomatter {
    NSDateFormatter * dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = fomatter;
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
   [dateF setTimeZone:tz];
    NSDate *date = [dateF dateFromString:str];
    date = [self getNowDateFromatAnDate:date];
    return date;
}

/// UTC时间转为当地时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    // 设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // 或GMT
    // 设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    // 得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    // 目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    // 得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    // 转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate]; return destinationDateNow;
}

/// 获取日期对应的某个月的天数
+ (NSInteger)getDaysInMonthWithDate:(NSDate *)theDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:theDate];
    return range.length;
}

/// 根据date获取当期月、或之前第几月、或之后第一月的date
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate*)date withMonth:(int)month {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

@end
