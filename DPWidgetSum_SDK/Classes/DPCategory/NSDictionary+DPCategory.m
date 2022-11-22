//
//  NSDictionary+DPCategory.m
//  DPWidgetSumDemo
//
//  Created by yupeng xia on 2021/9/18.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

#import "NSDictionary+DPCategory.h"
#import "DPWidgetSum.h"

@implementation NSDictionary (DPCategory)
- (BOOL)dp_hasKey {
    return [self count] > 0;
}
- (BOOL)dp_hasKey:(NSString *)key{
    NSArray *dataArray = [self allKeys];
    if([dataArray dp_containsString:key]){
        return YES;
    }
    return NO;
}

- (BOOL)dp_boolForKey:(NSString *)key{
    return [NSObject dp_BOOLOrNilOfData:[self objectForKey:key]];
}
- (int)dp_intForKey:(NSString *)key{
    return [NSObject dp_intOrNilOfData:[self objectForKey:key]];
}
- (NSInteger)dp_integerForKey:(NSString *)key{
    return [NSObject dp_integerOrNilOfData:[self objectForKey:key]];
}
- (CGFloat)dp_floatForKey:(NSString *)key{
    return [NSObject dp_floatOrNilOfData:[self objectForKey:key]];
}
- (double)dp_doubleForKey:(NSString *)key{
    return [NSObject dp_doubleOrNilOfData:[self objectForKey:key]];
}

- (NSString *)dp_stringForKey:(NSString *)key{
    return [NSObject dp_stringOrNilOfData:[self objectForKey:key]];
}
- (NSNumber *)dp_numberForKey:(NSString *)key{
    return [NSObject dp_numberOrNilOfData:[self objectForKey:key]];
}
- (NSArray *)dp_arrayForKey:(NSString *)key{
    return [NSObject dp_arrayOrNilOfData:[self objectForKey:key]];
}
- (NSDictionary *)dp_dictionaryForKey:(NSString *)key{
    return [NSObject dp_dictionaryOrNilOfData:[self objectForKey:key]];
}
- (NSData *)dp_dataForKey:(NSString *)key{
    return [NSObject dp_dataOrNilOfData:[self objectForKey:key]];
}
- (id)dp_objectValueForKey:(NSString *)key{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]){
        return [NSObject dp_stringOrNilOfData:value];
    }else if([value isKindOfClass:[NSNumber class]]){
        return [NSObject dp_numberOrNilOfData:value];
    }else if([value isKindOfClass:[NSArray class]]){
        return [NSObject dp_arrayOrNilOfData:value];
    }else if([value isKindOfClass:[NSDecimalNumber class]]){
        return [NSObject dp_numberOrNilOfData:value];
    }else if([value isKindOfClass:[NSDictionary class]]){
        return [NSObject dp_dictionaryOrNilOfData:value];
    }else if([value isKindOfClass:[NSData class]]){
        return [NSObject dp_dataOrNilOfData:value];
    }else {
        return value;
    }
}

- (NSMutableString *)dp_mutableStringForKey:(NSString *)key{
    NSString *obj = [NSObject dp_stringOrNilOfData:[self objectForKey:key]];
    if(nil != obj){
        return [NSMutableString stringWithFormat:@"%@",obj];
    }
    return [NSMutableString string];
}
- (NSMutableArray *)dp_mutableArrayForKey:(NSString *)key{
    NSArray *obj = [NSObject dp_arrayOrNilOfData:[self objectForKey:key]];
    if(nil != obj){
        return [NSMutableArray arrayWithArray:obj];
    }
    return [NSMutableArray array];
}
- (NSMutableDictionary *)dp_mutableDictionaryForKey:(NSString *)key{
    NSDictionary *obj = [NSObject dp_dictionaryOrNilOfData:[self objectForKey:key]];
    if(nil != obj){
        return [NSMutableDictionary dictionaryWithDictionary:obj];
    }
    return [NSMutableDictionary dictionary];
}
- (NSMutableData *)dp_mutableDataForKey:(NSString *)key{
    NSData *obj = [NSObject dp_dataOrNilOfData:[self objectForKey:key]];
    if(nil != obj){
        return [NSMutableData dataWithData:obj];
    }
    return [NSMutableData data];
}
@end
