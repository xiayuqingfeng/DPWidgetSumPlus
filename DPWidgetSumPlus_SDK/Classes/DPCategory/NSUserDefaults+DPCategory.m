//
//  NSArray+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "NSUserDefaults+DPCategory.h"
#import "DPCategory.h"

@implementation NSUserDefaults (DPCategory)

@end

@implementation NSUserDefaults (NSUserDefaultsCustomExtends)
+ (void)dp_setValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)dp_objectForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+ (void)dp_removeObjectForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
+ (NSString *)dp_stringForKey:(NSString *)key{
    return [NSObject dp_stringOrNilOfData:[[NSUserDefaults standardUserDefaults] stringForKey:key]];
}
+ (NSArray *)dp_arrayForKey:(NSString *)key{
    return [NSObject dp_arrayOrNilOfData:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
}
+ (NSDictionary *)dp_dictionaryForKey:(NSString *)key{
    return [NSObject dp_dictionaryOrNilOfData:[[NSUserDefaults standardUserDefaults] dictionaryForKey:key]];
}
+ (NSData *)dp_dataForKey:(NSString *)key{
    return[NSObject dp_dataOrNilOfData:[[NSUserDefaults standardUserDefaults] dataForKey:key]];
}
+ (NSArray *)dp_stringArrayForKey:(NSString *)key{
    return [NSObject dp_arrayOrNilOfData:[[NSUserDefaults standardUserDefaults] stringArrayForKey:key]];
}
+ (NSInteger)dp_integerForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}
+ (float)dp_floatForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}
+ (double)dp_doubleForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}
+ (BOOL)dp_boolForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+ (NSURL *)URLForKey:(NSString *)key NS_AVAILABLE(10_6, 4_0){
    return [[NSUserDefaults standardUserDefaults] URLForKey:key];
}
+ (void)dp_setObject:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)dp_setInteger:(NSInteger)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)dp_setFloat:(float)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)dp_setDouble:(double)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)dp_setBool:(BOOL)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)dp_setURL:(NSURL *)value forKey:(NSString *)key NS_AVAILABLE(10_6, 4_0){
    [[NSUserDefaults standardUserDefaults] setURL:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
