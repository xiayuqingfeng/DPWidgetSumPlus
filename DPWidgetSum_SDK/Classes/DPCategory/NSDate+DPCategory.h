//
//  NSDate+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DPCategory)
///时间格式化规则载体（默认中国时区 zh_CN），静态变量，防止多次创建消耗性能
+ (NSDateFormatter *)dp_sharedDateFormatter;

///获取当前时间，aDate 为空使[NSDate date]，用综合数据_包括（year、month、day、hour、minute、second、Weekday、WeekdayOrdinal、Quarter、WeekOfMonth、WeekOfYear、YearForWeekOfYear、Nanosecond、Calendar、TimeZone……）
+ (NSDateComponents *)dp_getCurrentDate:(NSDate *)aDate;

///获取当前时间，中国时区标（纠正时区偏差8个小时）
+ (NSDate *)dp_getLocalDateTime;

///国际时间转换为中国时区标准时间（纠正时区偏差8个小时）
+ (NSDate *)dp_getLocalDateTimeForInternationDate:(NSDate *)aDate;

///计算时间差，秒；
+ (NSTimeInterval)dp_dateSecondsDistanceForStartDate:(NSDate *)aStartDate endDate:(NSDate *)aEndDate;

///计算时间差，天；aIsAccurate：YES 精确值 两位小数 四舍五入，NO 粗略值 整数；
+ (NSString *)dp_dateSecondsDayForStartDate:(NSDate *)aStartDate endDate:(NSDate *)aEndDate isAccurate:(BOOL)aIsAccurate;

///获取中文周几，英文转中文
+ (NSString *)dp_cTransformFromE:(NSString *)theWeek;

///获取指定日期(前 或 后)N天的日期数组；aDate：指定日期；count：指定天数，正数值向前计算，负数值向后计算；aContainsDay：是否包含当天，YES 包含，NO 不包含；
+ (NSArray *)dp_getDateArrayForDate:(NSDate *)aDate count:(NSInteger)aCount containsDay:(BOOL)aContainsDay;

///获取NSDate；aDateStr：时间格式；aFormatterStr：相匹配的时间格式，为空自动识别；
+ (NSDate *)dp_getDateForDateStr:(NSString *)aDateStr formatterStr:(NSString *)aFormatterStr;

///获取NSDate（国际时区）；aDateStr：时间格式（中国时区 zh_CN）；aFormatterStr：相匹配的时间格式，为空自动识别；
+ (NSDate *)dp_getDateForLoaclDate:(NSString *)aLoaclDate formatterStr:(NSString *)aFormatterStr;

///获取NSString；aDateStr 任意格式时间；aFormatter 指定时间格式(NSDate | yyyy年MM月dd日 | yyyy年MM月 | MM月dd日…………)；aIsIntercept 是否截取”0“开头的占位符
+ (NSString *)dp_getStrForDateOrStr:(id)aDateStr formatter:(NSString *)aFormatter isIntercept:(BOOL)aIsIntercept;

///获取NSString（中国时区 zh_CN）；aDateStr 任意格式时间（国际时区）；aFormatter 指定时间格式(NSDate | yyyy年MM月dd日 | yyyy年MM月 | MM月dd日…………)；aIsIntercept 是否截取”0“开头的占位符
+ (NSString *)dp_getLocalStrForDateOrStr:(id)aDateStr formatter:(NSString *)aFormatter isIntercept:(BOOL)aIsIntercept;

///获取两个日期之间的所有日期(精确 day)数组；aContainsDay：是否包含开始时间和结束时间，YES 包含，NO 不包含，默认 NO；
+ (NSArray <NSDate *>*)dp_getDateSectionArrayForStartDate:(NSDate *)aStartDate endDate:(NSDate *)aEndDate containsDay:(BOOL)aContainsDay;

///获取某N个月前的日期，根据指定当前时间；date 指定时间；month 正数向前计算，负数向后计算；
+ (NSDate *)dp_getPriousorLaterDateFromDate:(NSDate*)date withMonth:(NSInteger)month;

///获取某N个小时前的日期，根据指定当前时间；date 指定时间；hour 正数向前计算，负数向后计算；
+ (NSDate *)dp_getPriousorLaterDateFromDate:(NSDate *)date withHour:(NSInteger)hour;

///获取某个月的天数
+ (NSInteger)dp_getSumOfDaysInMonth:(NSString *)yearStr month:(NSString *)monthStr;

///获取当指定月的所有日期数组（国际标准时间，时区差8个小时）
+ (NSArray <NSDate *>*)dp_getDayArrayForMonths:(NSDate *)date;

///比较时间，aType 精确值：0 年，1 月，2 天，3 小时，4 分钟，5 秒
+ (BOOL)dp_isSameForLeftDate:(NSDate *)aLeftDate rightDate:(NSDate *)aRightDate type:(NSInteger)aType;
@end

