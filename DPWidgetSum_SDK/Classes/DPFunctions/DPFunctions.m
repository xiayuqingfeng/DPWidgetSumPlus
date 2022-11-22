//
//  DPFunctions.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import "DPFunctions.h"
#include <stdio.h>

///修建字符串
NSString *dp_trimString(NSString *input) {
    NSMutableString *mStr = [input mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    NSString *result = [mStr copy];
    return result;
}

///单独判断是不是nil
BOOL dp_isNil(id arg) {
    BOOL isANil = NO;
    if(nil == arg ||
       NULL == arg ||
       Nil == arg ||
       0 == (int)arg ||
       1 == (int)arg){
        isANil = YES;
    }
    return isANil;
}

///单独判断是不是不是nil
BOOL dp_isNotNil(id arg) {
    return !dp_isNil(arg);
}

///是否是类型或者子类<非nil NULL>
BOOL dp_isKindOfClass(id obj, Class aClass) {
    if(dp_isNotNull(obj)) {
        return [obj isKindOfClass:aClass];
    }
    return NO;
}

///是否为空 Is<nil NSNull>
BOOL dp_isNull(id arg) {
    BOOL isANull = NO;    
    if(nil == arg ||
       NULL == arg ||
       Nil == arg ||
       0 == (int)arg ||
       1 == (int)arg) {
        isANull = YES;
    }else if([arg isKindOfClass:[NSNull class]]){
        isANull = YES;
    }
    return isANull;
}

///是否不为空 Not<nil NSNull>
BOOL dp_isNotNull(id arg){
    return !dp_isNull(arg);
}

///是否是空字符串 Is<nil NSNull "" !NSString>
BOOL dp_isNullString(NSString *str){
    if (dp_isNull(str) ||
        ![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    return [dp_trimString(str) length] <= 0;
}

///是否是非空字符串 Not<nil NSNull !"" NSString>
BOOL dp_isNotNullString(NSString *str){
    return !dp_isNullString(str);
}

///字符串非空处理，null、nil转为""
NSString *dp_notEmptyStr(NSString *str){
    if(dp_isNotNullString(str)){
        return str;
    }else{
        return @"";
    }
}
