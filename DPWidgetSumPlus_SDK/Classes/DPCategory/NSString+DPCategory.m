//
//  NSString+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "NSString+DPCategory.h"
#import "DPWidgetSumPlus.h"

@implementation NSString (DPCategory)
///字节长度，编码：kCFStringEncodingGB_18030_2000
- (NSUInteger)dp_charLength {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self dp_charLengthWithEncoding:encoding];
}

///字节长度，encoding 编码格式
- (NSUInteger)dp_charLengthWithEncoding:(NSStringEncoding)encoding {
    NSUInteger strLength = 0;
    char *p = (char *)[self cStringUsingEncoding:encoding];
    
    NSUInteger lengthOfBytes = [self lengthOfBytesUsingEncoding:encoding];
    for (int i = 0; i < lengthOfBytes; i++) {
        if (*p) {
            p++;
            strLength++;
        } else {
            p++;
        }
    }
    return strLength;
}

///获取字符串中多个相同字符串的所有range
- (NSArray <NSValue *>*)dp_rangeOfSubString:(NSString*)subStr {
    NSMutableArray <NSValue *>*rangeArray = [NSMutableArray array];
    //当前字符串，尾部拼接查找字符串，防止遍历查找越界
    NSString *sumString = [self stringByAppendingString:subStr];
    for(int i = 0; i < self.length; i ++) {
        NSString *temp = [sumString substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = {i,subStr.length};
            [rangeArray addObject:[NSValue valueWithRange:range]];
        }
    }
    return rangeArray;
}

//URL编码
- (NSString *)dp_urlEncodedString {
    NSString *encodeUrl = self;
    if (encodeUrl.length < 1) {
        return @"";
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (@available(iOS 9.0, *)) {
        encodeUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
#else
    if (!@available(iOS 9.0, *)) {
        encodeUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
#endif
    return encodeUrl;
}

//URL解码
- (NSString *)dp_urlDecodedString {
    NSString *decodeUrl = self;
    if (decodeUrl.length < 1) {
        return @"";
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (@available(iOS 9.0, *)) {
        decodeUrl = [self stringByRemovingPercentEncoding];
    }
#else
    if (!@available(iOS 9.0, *)) {
        decodeUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
#endif
    return self;
}

///防崩溃，扩展系统函数 rangeOfString:
- (NSRange)dp_rangeOfString:(NSString *)searchString {
    if (searchString != nil &&
        [searchString isKindOfClass:[NSString class]] &&
        searchString.length > 0) {
        return [self rangeOfString:searchString];
    }
    return NSMakeRange(0, 0);
}

///防崩溃，扩展系统函数 dp_stringByAppendingString:
- (NSString *)dp_stringByAppendingString:(NSString *)aString {
    if (aString != nil &&
        [aString isKindOfClass:[NSString class]] &&
        aString.length > 0) {
        return [self stringByAppendingString:aString];
    }
    return self;
}

///防崩溃，扩展系统函数 isEqualToString:
- (BOOL)dp_isEqualToString:(NSString *)aString {
    if (aString != nil &&
        [aString isKindOfClass:[NSString class]]) {
        return [self isEqualToString:aString];
    }
    return NO;
}

///字符串gzip压缩 (NSString-》NSData-》gzip压缩-》NSData-》base64 NSString)
+ (NSString *)dp_gzipDeflateStr:(NSString *)aStr {
    NSData *aData = [aStr dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1)];
    NSData *zipData = [NSData gzipDeflate:aData];
    NSString *gzipStr = [zipData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return gzipStr;
}

///字符串gzip解压 (base64 NSString-》NSData-》gzip解压-》NSData-》NSString)
+ (NSString *)dp_gzipInflateStr:(NSString *)aStr {
    NSData *aData = [[NSData alloc] initWithBase64EncodedString:aStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *unZipData = [NSData gzipInflate:aData];
    NSString *originalStr = [[NSString alloc] initWithData:unZipData encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1)];
    return originalStr;
}
@end

@implementation NSString (DPCategoryValue)
+ (NSString *)dp_char:(char)value {
    return [NSString stringWithFormat:@"%c",value];
}

+ (NSString *)dp_unsignedChar:(unsigned char)value {
    return [NSString stringWithFormat:@"%c",value];
}
+ (NSString *)dp_short:(short)value {
    return [NSString stringWithFormat:@"%d",value];
}
+ (NSString *)dp_unsignedShort:(unsigned short)value {
    return [NSString stringWithFormat:@"%d",value];
}
+ (NSString *)dp_int:(NSInteger)value {
    return [NSString stringWithFormat:@"%ld",(long)value];
}
+ (NSString *)dp_unsignedInt:(unsigned int)value {
    return [NSString stringWithFormat:@"%ud",value];
}
+ (NSString *)dp_long:(long)value {
    return [NSString stringWithFormat:@"%ld",value];
}
+ (NSString *)dp_unsignedLong:(unsigned long)value {
    return [NSString stringWithFormat:@"%lu",value];
}
+ (NSString *)dp_longLong:(long long)value {
    return [NSString stringWithFormat:@"%lld",value];
}
+ (NSString *)dp_unsignedLongLong:(unsigned long long)value {
    return [NSString stringWithFormat:@"%llu",value];
}
+ (NSString *)dp_float:(float)value {
    return [[self class] stringWithFormat:@"%f",value];
}
+ (NSString *)dp_float:(float)value count:(NSUInteger)aCount {
    return [[self class] stringWithFormat:@"%.2f",value];
}
+ (NSString *)dp_double:(double)value {
    return [NSString stringWithFormat:@"%lf",value];
}
+ (NSString *)dp_bool:(BOOL)value {
    int boolValue = 0;
    if(value) {
        boolValue = 1;
    }
    return [NSString stringWithFormat:@"%d",boolValue];
}
+ (NSString *)dp_integer:(NSInteger)value {
    return [NSString stringWithFormat:@"%ld",(long)value];
}
+ (NSString *)dp_unsignedInteger:(NSUInteger)value {
    return [NSString stringWithFormat:@"%lu",(unsigned long)value];
}
+ (NSString *)dp_number:(NSNumber*)value {
    return [NSString stringWithFormat:@"%@",value];
}
@end

@implementation NSString (DPCategoryRegular)
///获取正则格式，aType 当前正则类型：0  数字，1  小写字母，2  大写字母，3  汉字，4  大小写字母，5  数字/大小写字母，6  数字/大小写字母/汉字，7  数字/大小写字母/下划线/汉字，8 URL格式，9 数字/"Xx", 10 邮箱
+ (NSString *)dp_regularValueForType:(NSInteger)aType {
    NSString *regularStr = @"";
    if (aType == 0) {
        regularStr = @"^[0-9]*$";
    }else if (aType == 1) {
        regularStr = @"^[a-z]*$";
    }else if (aType == 2) {
        regularStr = @"^[A-Z]*$";
    }else if (aType == 3) {
        regularStr = @"^[\u4E00-\u9FA5]*$";
    }else if (aType == 4) {
        regularStr = @"^[a-zA-Z]*$";
    }else if (aType == 5) {
        regularStr = @"^[0-9a-zA-Z]*$";
    }else if (aType == 6) {
        regularStr = @"^[0-9a-zA-Z\u4E00-\u9FA5]*$";
    }else if (aType == 7) {
        regularStr = @"^[0-9a-zA-Z_\u4E00-\u9FA5]*$";
    }else if (aType == 8) {
        regularStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    }else if (aType == 9) {
        regularStr = @"^[0-9xX]*$";
    }else if (aType == 10) {
        regularStr = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    }
    return regularStr;
}

///谓词正则校验，aStr 当前校验字符串，aRegular 当前正则
+ (BOOL)dp_predicateRegularForStr:(NSString *)aStr regular:(NSString *)aRegular {
    if (aStr.length < 1 || aRegular.length < 1) {
        return NO;
    }else {
        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",aRegular];
        return [numberPre evaluateWithObject:aStr];
    }
}

///谓词正则校验，aStr 当前校验字符串，aType 当前正则格式（引用函数 dp_regularValueForType:）
+ (BOOL)dp_predicateRegularForStr:(NSString *)aStr type:(NSInteger)aType {
    NSString *regularStr = [NSString dp_regularValueForType:aType];
    return [NSString dp_predicateRegularForStr:aStr regular:regularStr];
}
@end
