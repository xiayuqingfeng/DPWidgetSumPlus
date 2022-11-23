//
//  NSString+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (DPCategory)
///字节长度，编码：kCFStringEncodingGB_18030_2000
- (NSUInteger)dp_charLength;

///字节长度，encoding 编码格式
- (NSUInteger)dp_charLengthWithEncoding:(NSStringEncoding)encoding;

///获取字符串中多个相同字符串的所有range
- (NSArray <NSValue *>*)dp_rangeOfSubString:(NSString*)subStr;

///URL编码
- (NSString *)dp_urlEncodedString;

///URL解码
- (NSString *)dp_urlDecodedString;

///防崩溃，扩展系统函数 rangeOfString:
- (NSRange)dp_rangeOfString:(NSString *)searchString;

///防崩溃，扩展系统函数 dp_stringByAppendingString:
- (NSString *)dp_stringByAppendingString:(NSString *)aString;

///防崩溃，扩展系统函数 isEqualToString:
- (BOOL)dp_isEqualToString:(NSString *)aString;

///字符串gzip压缩 (ISO 8859-1 编码格式; 输出字符串为,有球有料通用加密转码格式;)
+ (NSString *)dp_gzipDeflateStr:(NSString *)aStr;

///字符串gzip解压 (ISO 8859-1 编码格式; 输入字符串为,有球有料通用加密转码格式;)
+ (NSString *)dp_gzipInflateStr:(NSString*)aStr;
@end

@interface NSString (DPCategoryValue)
+ (NSString *)dp_char:(char)value;
+ (NSString *)dp_unsignedChar:(unsigned char)value;
+ (NSString *)dp_short:(short)value;
+ (NSString *)dp_unsignedShort:(unsigned short)value;
+ (NSString *)dp_int:(NSInteger)value;
+ (NSString *)dp_unsignedInt:(unsigned int)value;
+ (NSString *)dp_long:(long)value;
+ (NSString *)dp_unsignedLong:(unsigned long)value;
+ (NSString *)dp_longLong:(long long)value;
+ (NSString *)dp_unsignedLongLong:(unsigned long long)value;
+ (NSString *)dp_float:(float)value;
+ (NSString *)dp_float:(float)value count:(NSUInteger)aCount;
+ (NSString *)dp_double:(double)value;
+ (NSString *)dp_bool:(BOOL)value;
+ (NSString *)dp_integer:(NSInteger)value;
+ (NSString *)dp_unsignedInteger:(NSUInteger)value;
+ (NSString *)dp_number:(NSNumber*)value;
@end

@interface NSString (DPCategoryRegular)
///获取正则格式，aType 当前正则类型：0  数字，1  小写字母，2  大写字母，3  汉字，4  大小写字母，5  数字/大小写字母，6  数字/大小写字母/汉字，7  数字/大小写字母/下划线/汉字，8 URL格式，9 数字/"Xx", 10 邮箱
+ (NSString *)dp_regularValueForType:(NSInteger)aType;

///谓词正则校验，aStr 当前校验字符串，aRegular 当前正则
+ (BOOL)dp_predicateRegularForStr:(NSString *)aStr regular:(NSString *)aRegular;

///谓词正则校验，aStr 当前校验字符串，aType 当前正则格式（引用函数 dp_regularValueForType:）
+ (BOOL)dp_predicateRegularForStr:(NSString *)aStr type:(NSInteger)aType;
@end
