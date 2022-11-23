//
//  NSDate+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "NSDate+DPCategory.h"
#import "DPWidgetSumPlus.h"

@implementation NSDate (DPCategory)
///时间格式化规则载体（默认中国时区 zh_CN），静态变量，防止多次创建消耗性能
+ (NSDateFormatter *)dp_sharedDateFormatter {
    static NSDateFormatter *sharedFormatter;
    if (nil == sharedFormatter){
        sharedFormatter = [[NSDateFormatter alloc] init];
    }
    return sharedFormatter;
}

///获取当前时间，aDate 为空使[NSDate date]，用综合数据_包括（year、month、day、hour、minute、second、Weekday、WeekdayOrdinal、Quarter、WeekOfMonth、WeekOfYear、YearForWeekOfYear、Nanosecond、Calendar、TimeZone……）
+ (NSDateComponents *)dp_getCurrentDate:(NSDate *)aDate {
    if (aDate == nil) {
        aDate = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags =
    NSCalendarUnitEra | 
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter|
    NSCalendarUnitWeekOfMonth|
    NSCalendarUnitWeekOfYear|
    NSCalendarUnitYearForWeekOfYear|
    NSCalendarUnitNanosecond|
    NSCalendarUnitCalendar|
    NSCalendarUnitTimeZone;
    NSDateComponents *compDate = [calendar components:unitFlags fromDate:aDate];
    return compDate;
}

///获取中国时区标准时间（纠正时区偏差8个小时）
+ (NSDate *)dp_getLocalDateTime {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

///国际时间转换为中国时区标准时间（纠正时区偏差8个小时）
+ (NSDate *)dp_getLocalDateTimeForInternationDate:(NSDate *)aDate {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:aDate];
    NSDate *localeDate = [aDate dateByAddingTimeInterval:interval];
    return localeDate;
}

///计算时间差，秒；
+ (NSTimeInterval)dp_dateSecondsDistanceForStartDate:(NSDate *)aStartDate endDate:(NSDate *)aEndDate {
    return [aStartDate timeIntervalSinceDate:aEndDate];
}

///计算时间差，天；aIsAccurate：YES 精确值 两位小数 四舍五入，NO 粗略值 整数；
+ (NSString *)dp_dateSecondsDayForStartDate:(NSDate *)aStartDate endDate:(NSDate *)aEndDate isAccurate:(BOOL)aIsAccurate {
    NSDateFormatter *dateFormatter = [NSDate dp_sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval times = [aStartDate timeIntervalSinceDate:aEndDate];
    CGFloat days = times/(60.00 *60.00 *24.00);
    NSString *daysStr = @"";
    if (aIsAccurate) {
        daysStr = [NSString stringWithFormat:@"%0.2f",days];
    }else {
        daysStr = [NSString stringWithFormat:@"%ld",(long)days];
    }
    return daysStr;;
}

///获取中文周几，英文转中文
+ (NSString *)dp_cTransformFromE:(NSString *)theWeek {
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"]){
            chinaStr = @"周一";
        }else if([theWeek isEqualToString:@"Tuesday"]){
            chinaStr = @"周三";
        }else if([theWeek isEqualToString:@"Wednesday"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"]){
            chinaStr = @"七";
        }
    }
    return chinaStr;
}

///获取指定日期(前 或 后)N天的日期数组；aDate：指定日期；count：指定天数，正数值向前计算，负数值向后计算；aContainsDay：是否包含当天，YES 包含，NO 不包含；
+ (NSArray *)dp_getDateArrayForDate:(NSDate *)aDate count:(NSInteger)aCount containsDay:(BOOL)aContainsDay {
    if (aDate == nil) {
        return @[];
    }
    
    if (aContainsDay == NO) {
        //24小时
        NSTimeInterval secondsPerDay = 0;
        if (aCount > 0) {
            secondsPerDay = 24*60*60;
        }else {
            secondsPerDay = -24*60*60;
        }
        aDate = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:aDate];
    }
    
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < labs(aCount); i++) {
        //24小时
        NSTimeInterval secondsPerDay = 0;
        if (aCount > 0) {
            secondsPerDay = i*24*60*60;
        }else {
            secondsPerDay = -i*24*60*60;
        }
        
        NSDate *curDate = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:aDate];
        
        //时间格式年
        NSDateFormatter *formatter = [NSDate dp_sharedDateFormatter];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:curDate];
        
        //时间格式月
        [formatter setDateFormat:@"MM"];
        NSString *month = [formatter stringFromDate:curDate];
        
        //时间格式日
        [formatter setDateFormat:@"dd"];
        NSString *day = [formatter stringFromDate:curDate];
        
        //时间格式年月日
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *yearMonthDay = [formatter stringFromDate:curDate];
        
        //时间格式月日
        [formatter setDateFormat:@"MM-dd"];
        NSString *monthDay = [formatter stringFromDate:curDate];
        
        //星期
        [formatter setDateFormat:@"EEEE"];
        formatter.weekdaySymbols = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        NSString *week = [formatter stringFromDate:curDate];
        
        [dateArr addObject:@{@"year":dp_notEmptyStr(year),
                             @"month":dp_notEmptyStr(month),
                             @"day":dp_notEmptyStr(day),
                             @"yearMonthDay":dp_notEmptyStr(yearMonthDay),
                             @"monthDay":dp_notEmptyStr(monthDay),
                             @"week":dp_notEmptyStr(week)
        }];
    }
    return [NSArray arrayWithArray:dateArr];
}

///获取NSDate；aDateStr：时间格式；aFormatterStr：相匹配的时间格式，为空自动识别；
+ (NSDate *)dp_getDateForDateStr:(NSString *)aDateStr formatterStr:(NSString *)aFormatterStr {
    NSDateFormatter *formatter = [NSDate dp_sharedDateFormatter];
    return [NSDate dp_getDateForDateStr:aDateStr formatterStr:aFormatterStr dateFormatter:formatter];
}

///获取NSDate（国际时区）；aDateStr：时间格式（中国时区 zh_CN）；aFormatterStr：相匹配的时间格式，为空自动识别；
+ (NSDate *)dp_getDateForLoaclDate:(NSString *)aLoaclDate formatterStr:(NSString *)aFormatterStr {
    NSDateFormatter *formatter = [NSDate dp_sharedDateFormatter];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [NSDate dp_getDateForDateStr:aLoaclDate formatterStr:aFormatterStr dateFormatter:formatter];
}

+ (NSDate *)dp_getDateForDateStr:(NSString *)aDateStr formatterStr:(NSString *)aFormatterStr dateFormatter:(NSDateFormatter *)aDateFormatter {
    if (aDateStr.length < 1) {
        return nil;
    }

    NSDate *newDate = nil;
    if (aFormatterStr.length > 0) {
        [aDateFormatter setDateFormat:aFormatterStr];
        newDate = [aDateFormatter dateFromString:aDateStr];
        if (newDate != nil) {
            return newDate;
        }
    }
    
    NSArray *formatArray = @[@"yyyy-MM-dd HH:mm:ss",
                             @"yyyy-MM-dd HH:mm",
                             @"yyyy-MM-dd HH",
                             @"yyyy-MM-dd",
                             @"yyyy-MM",
                             @"yyyy",
                             @"MM-dd HH:mm:ss",
                             @"dd HH:mm:ss",
                             @"HH:mm:ss",
                             @"mm:ss",
                             @"ss",
                             @"MM-dd HH:mm",
                             @"MM-dd HH",
                             @"MM-dd",
                             @"MM",
                             @"dd HH:mm",
                             @"dd HH",
                             @"dd",
                             @"HH:mm",
                             @"HH",
                             @"mm",
                             @"yyyy年MM月dd日",
                             @"yyyy年MM月",
                             @"yyyy年",
                             @"MM月dd日",
                             @"MM月",
                             @"dd日",
                             @"yyyyMMddhhmmssSSS",
                             @"yyyyMMddhhmmss",
                             @"yyyyMMddhhmm",
                             @"yyyyMMddhh",
                             @"yyyyMMdd",
                             @"yyyyMM",
                             @"yyyy",
                             @"MMddhhmmssSSS",
                             @"ddhhmmssSSS",
                             @"hhmmssSSS",
                             @"mmssSSS",
                             @"ssSSS",
                             @"SSS"];
    for (NSString *currentFormat in formatArray) {
        [aDateFormatter setDateFormat:currentFormat];
        newDate = [aDateFormatter dateFromString:aDateStr];
        if (newDate != nil) {
            break;
        }
    }
    return newDate;
}

///获取NSString；aDateStr 任意格式时间；aFormatter 指定时间格式(NSDate | yyyy年MM月dd日 | yyyy年MM月 | MM月dd日…………)；aIsIntercept 是否截取”0“开头的占位符
+ (NSString *)dp_getStrForDateOrStr:(id)aDateStr formatter:(NSString *)aFormatter isIntercept:(BOOL)aIsIntercept {
    NSDateFormatter *formatter = [NSDate dp_sharedDateFormatter];
    return [NSDate dp_getStrForDateOrStr:aDateStr formatter:aFormatter isIntercept:aIsIntercept dateFormatter:formatter];
}

///获取NSString（中国时区 zh_CN）；aDateStr 任意格式时间（国际时区）；aFormatter 指定时间格式(NSDate | yyyy年MM月dd日 | yyyy年MM月 | MM月dd日…………)；aIsIntercept 是否截取”0“开头的占位符
+ (NSString *)dp_getLocalStrForDateOrStr:(id)aDateStr formatter:(NSString *)aFormatter isIntercept:(BOOL)aIsIntercept {
    NSDateFormatter *formatter = [NSDate dp_sharedDateFormatter];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    return [NSDate dp_getStrForDateOrStr:aDateStr formatter:aFormatter isIntercept:aIsIntercept dateFormatter:formatter];
}

+ (NSString *)dp_getStrForDateOrStr:(id)aDateStr formatter:(NSString *)aFormatter isIntercept:(BOOL)aIsIntercept dateFormatter:(NSDateFormatter *)aDateFormatter {
    if (aDateStr == nil) {
        return @"";
    }

    NSDate *newDate = nil;
    if ([aDateStr isKindOfClass:[NSDate class]]) {
        if (aFormatter.length < 1) {
            aFormatter = @"yyyy-MM-dd HH:mm:ss";
        }
        
        //直接转换NSDate
        newDate = aDateStr;
    }else if ([aDateStr isKindOfClass:[NSString class]]) {
        if (((NSString *)aDateStr).length < 1) {
            return @"";
        }
        if (aFormatter.length < 1) {
            return aDateStr;
        }
        
        //标准格式时间转NSDate
        NSArray *formatArray = @[@"yyyy-MM-dd HH:mm:ss",
                                 @"yyyy-MM-dd HH:mm",
                                 @"yyyy-MM-dd HH",
                                 @"yyyy-MM-dd",
                                 @"yyyy-MM",
                                 @"yyyy",
                                 @"-MM-dd HH:mm:ss",
                                 @"-dd HH:mm:ss",
                                 @"yyyy-MM-dd",
                                 @"yyyy-MM-",
                                 @"yyyy-",
                                 @"MM-dd HH:mm:ss",
                                 @"dd HH:mm:ss",
                                 @"HH:mm:ss",
                                 @"mm:ss",
                                 @"ss",
                                 @"MM-dd HH:mm",
                                 @"MM-dd HH",
                                 @"MM-dd",
                                 @"MM",
                                 @"dd HH:mm",
                                 @"dd HH",
                                 @"dd",
                                 @"HH:mm",
                                 @"HH",
                                 @"mm",
                                 @"yyyy年MM月dd日",
                                 @"yyyy年MM月",
                                 @"yyyy年",
                                 @"MM月dd日",
                                 @"MM月",
                                 @"dd日",
                                 @"yyyyMMddhhmmssSSS",
                                 @"yyyyMMddhhmmss",
                                 @"yyyyMMddhhmm",
                                 @"yyyyMMddhh",
                                 @"yyyyMMdd",
                                 @"yyyyMM",
                                 @"yyyy",
                                 @"MMddhhmmssSSS",
                                 @"ddhhmmssSSS",
                                 @"hhmmssSSS",
                                 @"mmssSSS",
                                 @"ssSSS",
                                 @"SSS"];
        for (NSString *currentFormat in formatArray) {
            [aDateFormatter setDateFormat:currentFormat];
            newDate = [aDateFormatter dateFromString:aDateStr];
            if (newDate != nil) {
                break;
            }
        }
        
        if (newDate == nil) {
            return aDateStr;
        }
    }else {
        return @"";
    }
    
    [aDateFormatter setDateFormat:aFormatter];
    NSString *customFormatter = [aDateFormatter stringFromDate:newDate];
    
    if (customFormatter.length < 1) {
        if ([[aDateStr class] isKindOfClass:[NSString class]]) {
            return aDateStr;
        }else {
            return @"";
        }
    }
    
    //时间截取”0“开头的占位符
    if (aIsIntercept) {
        if ([customFormatter rangeOfString:@"年0"].location != NSNotFound) {
            customFormatter = [customFormatter stringByReplacingOccurrencesOfString:@"年0" withString:@"年"];
        }
        if ([customFormatter rangeOfString:@"月0"].location != NSNotFound) {
            customFormatter = [customFormatter stringByReplacingOccurrencesOfString:@"月0" withString:@"月"];
        }
        if ([customFormatter rangeOfString:@"时0"].location != NSNotFound) {
            customFormatter = [customFormatter stringByReplacingOccurrencesOfString:@"时0" withString:@"时"];
        }
        if ([customFormatter rangeOfString:@"分0"].location != NSNotFound) {
            customFormatter = [customFormatter stringByReplacingOccurrencesOfString:@"分0" withString:@"分"];
        }
        if ([customFormatter rangeOfString:@" 0"].location != NSNotFound) {
            customFormatter = [customFormatter stringByReplacingOccurrencesOfString:@" 0" withString:@" "];
        }
        if ([customFormatter rangeOfString:@"-0"].location != NSNotFound) {
            customFormatter = [customFormatter stringByReplacingOccurrencesOfString:@"-0" withString:@"-"];
        }
        if ([customFormatter hasPrefix:@"0"]) {
            customFormatter = [customFormatter substringFromIndex:1];
        }
    }
    
    return customFormatter;
}

///获取两个日期之间的所有日期(精确 day)数组；aContainsDay：是否包含开始时间和结束时间，YES 包含，NO 不包含，默认 NO；
+ (NSArray <NSDate *>*)dp_getDateSectionArrayForStartDate:(NSDate *)aStartDate endDate:(NSDate *)aEndDate containsDay:(BOOL)aContainsDay {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *compStart = [calendar components:unitFlags fromDate:aStartDate];
    NSDateComponents *compEnd = [calendar components:unitFlags fromDate:aEndDate];
    if (compStart.year == compEnd.year
        && compStart.month == compEnd.month
        && compStart.day == compEnd.day) {
        if (aContainsDay) {
            return @[aStartDate];
        }else {
            return @[];
        }
    }
    
    NSDate *minDate = aStartDate;
    NSDate *maxDate = aEndDate;
    if ([minDate compare:maxDate] == NSOrderedDescending) {
        minDate = aEndDate;
        maxDate = aStartDate;
    }
    
    NSMutableArray *dateArr = [NSMutableArray arrayWithCapacity:0];
    NSDate *curDate = minDate;
    while ([curDate compare:maxDate] == NSOrderedAscending) {
        if ([curDate compare:minDate] == NSOrderedDescending) {
            [dateArr addObject:curDate];
        }
        NSTimeInterval secondsPerDay = 24*60*60;
        curDate = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:curDate];
    }
    
    if (aContainsDay) {
        [dateArr insertObject:minDate atIndex:0];
        [dateArr addObject:maxDate];
    }
    return [NSArray arrayWithArray:dateArr];
}

///获取某N个月前的日期，根据指定当前时间；date 指定时间；month 正数向前计算，负数向后计算；
+ (NSDate *)dp_getPriousorLaterDateFromDate:(NSDate*)date withMonth:(NSInteger)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    if (mDate == nil) {
        return date;
    }
    return mDate;
}

///获取某N个小时前的日期，根据指定当前时间；date 指定时间；hour 正数向前计算，负数向后计算；
+ (NSDate *)dp_getPriousorLaterDateFromDate:(NSDate *)date withHour:(NSInteger)hour {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:hour];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    if (mDate == nil) {
        return date;
    }
    return mDate;
}

///获取某个月的天数
+ (NSInteger)dp_getSumOfDaysInMonth:(NSString *)yearStr month:(NSString *)monthStr{
    NSDateFormatter *formatter = [NSDate dp_sharedDateFormatter];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",yearStr,monthStr];
    NSDate *date = [formatter dateFromString:dateStr];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit:NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}

///获取当指定月的所有日期数组（国际标准时间，时区差8个小时）
+ (NSArray <NSDate *>*)dp_getDayArrayForMonths:(NSDate *)date {
    //获取当月第一天 和 最后一天（国际标准时间，时区差8个小时）
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL bol = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    if (bol) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @[];
    }
    NSArray *dateArray = [NSDate dp_getDateSectionArrayForStartDate:beginDate endDate:endDate containsDay:YES];
    
    //当月日期数组去重
    NSMutableArray *newDateArray = [NSMutableArray arrayWithCapacity:dateArray.count];
    for (NSDate *aDate in dateArray) {
        BOOL bol = NO;
        if ([newDateArray containsObject:aDate]) {
            bol = YES;
        }else {
            for (NSDate *aCurrentDate in newDateArray) {
                NSCalendar *calendar = [NSCalendar currentCalendar];
                unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
                NSDateComponents *compLeft = [calendar components:unitFlags fromDate:aDate];
                NSDateComponents *compRight = [calendar components:unitFlags fromDate:aCurrentDate];
                bol = compLeft.year == compRight.year && compLeft.month == compRight.month && compLeft.day == compRight.day;
            }
        }
        if (bol == NO) {
            [newDateArray addObject:aDate];
        }
    }
    return newDateArray;
}

///比较时间，aType 精确值：0 年，1 月，2 天，3 小时，4 分钟，5 秒
+ (BOOL)dp_isSameForLeftDate:(NSDate *)aLeftDate rightDate:(NSDate *)aRightDate type:(NSInteger)aType {
    unsigned unitFlags = NSCalendarUnitYear;
    if (aType == 0) {
        unitFlags = NSCalendarUnitYear;
    }
    if (aType == 1) {
        unitFlags = unitFlags | NSCalendarUnitMonth;
    }
    if (aType == 2) {
        unitFlags = unitFlags | NSCalendarUnitMonth | NSCalendarUnitDay;
    }
    if (aType == 3) {
        unitFlags = unitFlags | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    }
    if (aType == 4) {
        unitFlags = unitFlags | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    }
    if (aType == 5) {
        unitFlags = unitFlags | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compLeft = [calendar components:unitFlags fromDate:aLeftDate];
    NSDateComponents *compRight = [calendar components:unitFlags fromDate:aRightDate];
    BOOL bol = YES;
    if (aType == 0) {
        bol = bol && compLeft.year == compRight.year;
    }
    if (aType == 1) {
        bol = bol && compLeft.year == compRight.year && compLeft.month == compRight.month;
    }
    if (aType == 2) {
        bol = bol && compLeft.year == compRight.year && compLeft.month == compRight.month && compLeft.day == compRight.day;
    }
    if (aType == 3) {
        bol = bol && compLeft.year == compRight.year && compLeft.month == compRight.month && compLeft.day == compRight.day && compLeft.hour == compRight.hour;
    }
    if (aType == 4) {
        bol = bol && compLeft.year == compRight.year && compLeft.month == compRight.month && compLeft.day == compRight.day && compLeft.hour == compRight.hour && compLeft.minute == compRight.minute;
    }
    if (aType == 5) {
        bol = bol && compLeft.year == compRight.year && compLeft.month == compRight.month && compLeft.day == compRight.day && compLeft.hour == compRight.hour && compLeft.minute == compRight.minute && compLeft.second == compRight.second;
    }
    return bol;
}
@end
