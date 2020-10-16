/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen
 
 Include GMT and time zone utilities?
 */

#import "NSDate+Extension.h"

// Thanks, AshFurrow
static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (Utilities)

// resolve iOS7/8 crash issues http://stackoverflow.com/questions/24624137/ios-nscalendar-crash-references-issue
+ (NSCalendar *) currentCalendar
{
    return [NSCalendar autoupdatingCurrentCalendar];
}

#pragma mark - Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days selectDate:(NSDate *)selectDate
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days selectDate:selectDate];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - String Properties
- (NSString *) stringWithFormat: (NSString *) format
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}

- (NSString *) shortString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) shortDateString
{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) mediumString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) mediumDateString
{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) longString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longTimeString
{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) longDateString
{
    return [self stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}

#pragma mark - Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL) isLastMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

- (BOOL) isNextMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *) dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingYears: (NSInteger) dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate *) dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateByAddingDays: (NSInteger) dDays selectDate:(NSDate *)selectDate
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:selectDate options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Extremes

- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *) dateAtEndOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

+ (NSDate *)dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}


#pragma mark - Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark - Decomposing Dates

- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger) hour
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger) day
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfYear;
}

- (NSInteger) weekday
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger) year
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}
+ (NSString *)getDateYear{
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];

    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    NSString *resultDate = [NSString stringWithFormat:@"%@",year];
    return resultDate;
}

+ (NSString *)getDateYearMonth {
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];

    
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    
    NSString *resultDate = [NSString stringWithFormat:@"%@-%@",year,month];
    return resultDate;
}
+ (NSString *)getDateYearMonthDay {
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];
    NSString * day = [NSString stringWithFormat:@"%ld",[dateComponent day]];

    
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    if (day.length == 1)
    {
        day = [NSString stringWithFormat:@"0%@",day];
    }
    NSString *resultDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    return resultDate;
}
+ (NSString *)getTomarowDateYearMonthDay{
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    [dateComponent setDay:[dateComponent day] + 1];
    
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];
    NSString * day = [NSString stringWithFormat:@"%ld",[dateComponent day]];
    
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    if (day.length == 1)
    {
        day = [NSString stringWithFormat:@"0%@",day];
    }
    NSString *resultDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    return resultDate;
}
+ (NSString *)getYesterdayDateYearMonthDay{
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    [dateComponent setDay:[dateComponent day] -  1];
    
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];
    NSString * day = [NSString stringWithFormat:@"%ld",[dateComponent day]];
    
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    if (day.length == 1)
    {
        day = [NSString stringWithFormat:@"0%@",day];
    }
    NSString *resultDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    return resultDate;
}
/*
 * @DO 获取指定日期的农历日期
 * @param date [指定日期]
 * @return (NSString)[指定日期的农历字符串]
 */
+(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    //定义农历数据:
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉",
                             @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未",
                             @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳",
                             @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑",
                             @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑",
                             @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥", nil];
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月",
                            @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@%@",y_str,m_str,d_str];

    return chineseCal_str;
}

+(NSString*)getLunarDayWithDate:(NSDate *)date{
    //定义农历数据:
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@",d_str];
    
    return chineseCal_str;
}

+ (NSString *)getYearMonthDayIncludeHanZiForDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];
    NSString * day = [NSString stringWithFormat:@"%ld",[dateComponent day]];

    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    if (day.length == 1)
    {
        day = [NSString stringWithFormat:@"0%@",day];
    }
    NSString *resultDate = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    return resultDate;
}
+ (NSString *)getYearMonthIncludeHanZi:(NSDate*)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];
    
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    
    NSString *resultDate = [NSString stringWithFormat:@"%@年%@月",year,month];
    return resultDate;
}

+ (NSString *)getYearMonthIncludeHanZi
{
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    NSString * year = [NSString stringWithFormat:@"%ld",[dateComponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",[dateComponent month]];

    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }

    NSString *resultDate = [NSString stringWithFormat:@"%@年%@月",year,month];
    return resultDate;
}

+ (NSString *)getHourMinuteSecond
{
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    NSString * hour = [NSString stringWithFormat:@"%02ld", (long)[dateComponent hour]];
    NSString * minute = [NSString stringWithFormat:@"%02ld", (long)[dateComponent minute]];
    NSString * second = [NSString stringWithFormat:@"%02ld", (long)[dateComponent second]];
    
    NSString *resultDate = [NSString stringWithFormat:@"%@:%@:%@",hour,minute,second];
    return resultDate;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}
+(NSString *)getNowTimeTimestamp{
    
    NSDate *timeDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *locationString = [dateFormatter stringFromDate:timeDate];
    return locationString;
    
}
+(NSDate *)getDatewith:(NSString *)dateStr WithTtpe:(NSString *)type{
    if ([type isEqualToString:@"yy-MM-dd HH:mm"]) {
            // 实例化NSDateFormatter
        NSString * detailDateStr = [NSString stringWithFormat:@"%@:00",dateStr];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置日期格式
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // 设置为UTC时区
        // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        // 要转换的日期字符串
        NSDate *someDay = [formatter dateFromString:detailDateStr];
        return someDay;
    }else if ([type isEqualToString:@"yy-MM-dd HH:mm:ss"]){
        NSString * detailDateStr = [NSString stringWithFormat:@"%@",dateStr];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置日期格式
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // 设置为UTC时区
        // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
        //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        // 要转换的日期字符串
        NSDate *someDay = [formatter dateFromString:detailDateStr];
        return someDay;
    }else{
        // 实例化NSDateFormatter
        NSString * detailDateStr = [NSString stringWithFormat:@"%@ 12:00:00",dateStr];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置日期格式
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // 设置为UTC时区
        // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        // 要转换的日期字符串
        NSDate *someDay = [formatter dateFromString:detailDateStr];
        return someDay;
    }

}
-(NSInteger )cateleDateWithDateStr:(NSString *)dateStr andDateStr:(NSString *)dateEndStr{
    //要转换的字符串
    //字符串转NSDate格式的方法
    NSDate * ValueDate = [self StringTODate:dateStr];
    NSDate * ValueDate2 = [self StringTODate:dateEndStr];
    //计算两个中间差值(秒)
    NSTimeInterval time = [ValueDate2 timeIntervalSinceDate:ValueDate];
    
    //开始时间和结束时间的中间相差的时间
    int days;
    days = ((int)time)/(3600*24);  //一天是24小时*3600秒
    return days;
}

- (NSDate *)StringTODate:(NSString *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MMMM-dd";
    [dateFormatter setMonthSymbols:[NSArray arrayWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil]];
    NSDate * ValueDate = [dateFormatter dateFromString:sender];
    return ValueDate;

}
@end
