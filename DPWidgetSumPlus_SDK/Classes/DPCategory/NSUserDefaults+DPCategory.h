//
//  NSArray+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (DPCategory)

@end

@interface NSUserDefaults (NSUserDefaultsCustomExtends)
+ (void)dp_setValue:(id)value forKey:(NSString *)key;
+ (id)dp_objectForKey:(NSString *)key;
+ (void)dp_removeObjectForKey:(NSString*)key;
+ (NSString *)dp_stringForKey:(NSString *)key;
+ (NSArray *)dp_arrayForKey:(NSString *)key;
+ (NSDictionary *)dp_dictionaryForKey:(NSString *)key;
+ (NSData *)dp_dataForKey:(NSString *)key;
+ (NSArray *)dp_stringArrayForKey:(NSString *)key;
+ (NSInteger)dp_integerForKey:(NSString *)key;
+ (float)dp_floatForKey:(NSString *)key;
+ (double)dp_doubleForKey:(NSString *)key;
+ (BOOL)dp_boolForKey:(NSString *)key;
+ (NSURL *)URLForKey:(NSString *)key NS_AVAILABLE(10_6, 4_0);


+ (void)dp_setInteger:(NSInteger)value forKey:(NSString *)key;
+ (void)dp_setFloat:(float)value forKey:(NSString *)key;
+ (void)dp_setDouble:(double)value forKey:(NSString *)key;
+ (void)dp_setObject:(id)value forKey:(NSString *)key;
+ (void)dp_setBool:(BOOL)value forKey:(NSString *)key;
+ (void)dp_setURL:(NSURL *)value forKey:(NSString *)key NS_AVAILABLE(10_6, 4_0);
@end
