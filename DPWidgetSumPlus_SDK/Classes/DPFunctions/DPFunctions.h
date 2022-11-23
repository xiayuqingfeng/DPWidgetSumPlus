//
//  DPFunctions.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///修建字符串
NSString *dp_trimString(NSString *input);

///单独判断是不是nil
BOOL dp_isNil(id arg);

///单独判断是不是不是nil
BOOL dp_isNotNil(id arg);

///是否是类型或者子类<非nil NULL>
BOOL dp_isKindOfClass(id obj,Class aClass);

///是否为空 Is<nil NSNull>
BOOL dp_isNull(id arg);

///是否不为空 Not<nil NSNull>
BOOL dp_isNotNull(id arg);

///是否是空字符串 Is<nil NSNull "" !NSString>
BOOL dp_isNullString(NSString *str);

///是否是非空字符串 Not<nil NSNull !"" NSString>
BOOL dp_isNotNullString(NSString *str);

///字符串非空处理，null、nil转为""
NSString *dp_notEmptyStr(NSString *str);
