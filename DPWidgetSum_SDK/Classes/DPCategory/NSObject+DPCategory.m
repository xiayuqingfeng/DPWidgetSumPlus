//
//  NSObject+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "NSObject+DPCategory.h"
#import "DPWidgetSum.h"
#import <objc/runtime.h>

@implementation NSObject (DPCategory)
///所有NSString类型变量为nil时，设置值为@""
- (void)dp_setDefaultValueForAllStringProperty {
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyType = [[NSString alloc] initWithCString:property_copyAttributeValue(property, "T") encoding:NSUTF8StringEncoding];
        //NSLog(@"property_name: %@, property_type: %@",propertyName,propertyType);
        if (propertyName.length > 0 && propertyType.length > 0  && [propertyType rangeOfString:@"NSString"].location != NSNotFound) {
            NSString *aValue = [self valueForKeyPath:propertyName];
            if (aValue == nil || aValue == NULL || aValue == Nil) {
                [self setValue:@"" forKey:propertyName];
            }
        }
    }
    free(properties);
}
///重置所有NSString、NSDictionary、NSMutableArray……类型变量为空数据
- (void)dp_clearValueForAllStringProperty {
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyType = [[NSString alloc] initWithCString:property_copyAttributeValue(property, "T") encoding:NSUTF8StringEncoding];
        NSLog(@"property_name: %@, property_type: %@",propertyName,propertyType);
        if (propertyName.length > 0 && propertyType.length > 0  && [propertyType rangeOfString:@"NSString"].location != NSNotFound) {
            [self setValue:@"" forKey:propertyName];
        }else if (propertyName.length > 0 && propertyType.length > 0  && [propertyType rangeOfString:@"NSDictionary"].location != NSNotFound) {
            [self setValue:[@{} mutableCopy] forKey:propertyName];
        }else if (propertyName.length > 0 && propertyType.length > 0  && [propertyType rangeOfString:@"NSArray"].location != NSNotFound) {
            [self setValue:[@[] mutableCopy] forKey:propertyName];
        }
    }
    free(properties);
}
@end

@implementation NSObject (Runtime)
///标记 id 数据
static void *dpIndentObjectStatic;
- (void)setDpIndentObject:(NSIndexPath *)aValue {
    objc_setAssociatedObject(self, &dpIndentObjectStatic, aValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSIndexPath *)dpIndentObject {
    return objc_getAssociatedObject(self, &dpIndentObjectStatic);
}

///标记 UIButton 数据
static void *dpIndentButtonStatic;
- (void)setDpIndentButton:(UIButton *)aValue {
    objc_setAssociatedObject(self, &dpIndentButtonStatic, aValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIButton *)dpIndentButton {
    return objc_getAssociatedObject(self, &dpIndentButtonStatic);
}

///标记 NSDictionary 数据
static void *dpIndentDictionaryStatic;
- (void)setDpIndentDictionary:(NSDictionary *)aValue {
    objc_setAssociatedObject(self, &dpIndentDictionaryStatic, aValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary *)dpIndentDictionary {
    return objc_getAssociatedObject(self, &dpIndentDictionaryStatic);
}

///标记 NSArray 数据
static void *dpIndentNSArrayStatic;
- (void)setDpIndentNSArray:(NSArray *)aValue {
    objc_setAssociatedObject(self, &dpIndentNSArrayStatic, aValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray *)dpIndentNSArray {
    return objc_getAssociatedObject(self, &dpIndentNSArrayStatic);
}

///标记 NSString 数据
static void *dpIndentStringStatic;
- (void)setDpIndentString:(NSString *)aValue {
    objc_setAssociatedObject(self, &dpIndentStringStatic, aValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)dpIndentString {
    return objc_getAssociatedObject(self, &dpIndentStringStatic);
}

///标记 NSIndexPath 数据
static void *dpIndentIndexPathStatic;
- (void)setDpIndentIndexPath:(NSIndexPath *)aValue {
    objc_setAssociatedObject(self, &dpIndentIndexPathStatic, aValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSIndexPath *)dpIndentIndexPath {
    return objc_getAssociatedObject(self, &dpIndentIndexPathStatic);
}

///标记 CGFloat 数据
static void *dpIndentFloatStatic;
- (void)setDpIndentFloat:(CGFloat)aValue {
    objc_setAssociatedObject(self, &dpIndentFloatStatic, [NSNumber numberWithFloat:aValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)dpIndentFloat {
    return [objc_getAssociatedObject(self, &dpIndentFloatStatic) floatValue];
}

///标记 NSInteger 数据
static void *dpIndentIntegerStatic;
- (void)setDpIndentInteger:(NSInteger)aValue {
    objc_setAssociatedObject(self, &dpIndentIntegerStatic, [NSNumber numberWithUnsignedInteger:aValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)dpIndentInteger {
    return [objc_getAssociatedObject(self, &dpIndentIntegerStatic) unsignedIntegerValue];
}

///标记 BOOL 数据
static void *dpIndentBoolStatic;
- (void)setDpIndentBool:(BOOL)aValue {
    objc_setAssociatedObject(self, &dpIndentBoolStatic, aValue?@1:@0, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)dpIndentBool {
    return [objc_getAssociatedObject(self, &dpIndentBoolStatic) boolValue];
}
@end

@implementation NSObject (FaultTolerance)
+ (id)dp_numberOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return [NSNumber numberWithInt:0];
    
    if ([data isKindOfClass:[NSNumber class]]) {
        return data;
    }
    return [NSNumber numberWithInt:0];
}
+ (BOOL)dp_BOOLOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return NO;
    
    if ([data isKindOfClass:[NSNumber class]]||[data isKindOfClass:[NSString class]]) {
        return [data intValue] > 0;
    }
    return NO;
}
+ (int)dp_intOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return -1;
    
    if ([data isKindOfClass:[NSNumber class]]||[data isKindOfClass:[NSString class]]) {
        if([data intValue]==-1) return -1;
        return [data intValue];
    }
    return -1;
}
+ (NSInteger)dp_integerOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return -1;
    
    if ([data isKindOfClass:[NSNumber class]]||[data isKindOfClass:[NSString class]]) {
        if([data integerValue]==-1) return -1;
        return [data integerValue];
    }
    return -1;
}
+ (CGFloat)dp_floatOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return 0.f;
    
    if ([data isKindOfClass:[NSNumber class]]||[data isKindOfClass:[NSString class]]) {
        if([data floatValue] ==0.f) return 0.f;
        return [data floatValue];
    }
    return 0.f;
}
+ (double)dp_doubleOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return 0.f;
    
    if ([data isKindOfClass:[NSNumber class]]||[data isKindOfClass:[NSString class]]) {
        if([data doubleValue] ==0.f) return 0.f;
        return [data doubleValue];
    }
    return 0.f;
}
+ (NSArray*)dp_arrayOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return @[];
    
    if ([data isKindOfClass:[NSArray class]]) {
        if([[NSArray arrayWithObject:data] count])
            return data;
        else
            return @[];
    }
    return @[];
}
+ (NSMutableArray *)dp_arrayMutabledOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return [NSMutableArray array];
    
    if ([data isKindOfClass:[NSArray class]]) {
        if([[NSArray arrayWithObject:data] count])
            return [NSMutableArray arrayWithArray:data];
        else
            return [NSMutableArray array];
    }
    return [NSMutableArray array];
}
+ (NSDictionary *)dp_dictionaryOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return [NSDictionary dictionary];
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        if([data allKeys].count)
            return data;
        else
            return [NSDictionary dictionary];
    }
    return [NSDictionary dictionary];
}

+ (id)dp_dataOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return [NSData data];
    
    if ([data isKindOfClass:[NSData class]]) {
        if([data length])
            return data;
        else
            return [NSData data];
    }
    return [NSData data];
}
+ (id)dp_stringOrNilOfData:(id)data {
    if(data==nil||[data isKindOfClass:[NSNull class]]) return @"";
    
    if ([data isKindOfClass:[NSString class]]){
        if([data length]<=0){
            return @"";
        }else{
            return data;
        }
    }
    else
        return [NSString stringWithFormat:@"%@",data];
    
    return @"";
}
@end
