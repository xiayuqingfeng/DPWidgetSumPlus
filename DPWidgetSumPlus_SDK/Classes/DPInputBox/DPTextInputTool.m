//
//  DPTextInputTool.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPTextInputTool.h"
#import "DPWidgetSumPlus.h"

@implementation DPTextInputTool
//正则匹配
+ (BOOL)regularCheckText:(NSString *)aText regularStr:(NSString *)aRegularStr {
    if (aText.length < 1 || aRegularStr.length < 1) {
        return NO;
    }
    
    NSError *error;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:aRegularStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        return NO;
    }
    
    NSUInteger number = [regExp numberOfMatchesInString:aText options:0 range:NSMakeRange(0, aText.length)];
    return number != 0;
}

//正则替换
+ (NSString *)regularReplacText:(NSString *)aText replacStr:(NSString *)aReplacStr regularStr:(NSString *)aRegularStr {
    if (aText == nil) {
        aText = @"";
    }
    
    if (aText.length < 1 || aRegularStr.length < 1) {
        return aText;
    }

    NSError *error;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:aRegularStr options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        return aText;
    }
    
    NSString *newStr = [regExp stringByReplacingMatchesInString:aText options:NSMatchingReportProgress range:NSMakeRange(0, aText.length) withTemplate:aReplacStr];
    
    if (newStr == nil) {
        newStr = @"";
    }
    return newStr;
}


///删除不可编码字符，编码格式：kCFStringEncodingGB_18030_2000
+ (NSString *)deleteUnableEncodeWithStr:(NSString *)aStr {
    if (aStr == nil) {
        return nil;
    }
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if ([aStr canBeConvertedToEncoding:encoding]) {
        return aStr;
    }else {
        NSMutableString *tempText = [NSMutableString stringWithFormat:@"%@",aStr];
        
        NSInteger index = 0;
        while (![tempText canBeConvertedToEncoding:encoding] && index < tempText.length) {
            NSRange aRange = [tempText   rangeOfComposedCharacterSequencesForRange:NSMakeRange(index, 1)];
            NSString *rangStr = [tempText substringWithRange:aRange];
            if (![rangStr canBeConvertedToEncoding:encoding]) {
                [tempText deleteCharactersInRange:aRange];
            }
            index++;
        }
        
        return tempText;
    }
}

///字符串字节计算，编码：kCFStringEncodingGB_18030_2000
+ (NSUInteger)byteCountWithStr:(NSString *)aStr {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSUInteger strLength = 0;
    char *p = (char *)[aStr cStringUsingEncoding:encoding];
    
    NSUInteger lengthOfBytes = [aStr lengthOfBytesUsingEncoding:encoding];
    for (int i = 0; i < lengthOfBytes; i++) {
        if (*p) {
            p++;
            strLength++;
        }else {
            p++;
        }
    }
    return strLength;
}
@end
