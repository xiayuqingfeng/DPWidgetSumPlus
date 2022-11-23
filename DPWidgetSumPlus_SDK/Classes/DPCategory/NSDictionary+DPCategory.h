//
//  NSDictionary+DPCategory.h
//  DPWidgetSumPlusDemo
//
//  Created by yupeng xia on 2021/9/18.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (DPCategory)
- (BOOL)dp_hasKey;
- (BOOL)dp_hasKey:(NSString *)key;

- (BOOL)dp_boolForKey:(NSString *)key;
- (int)dp_intForKey:(NSString *)key;
- (NSInteger)dp_integerForKey:(NSString *)key;
- (CGFloat)dp_floatForKey:(NSString *)key;
- (double)dp_doubleForKey:(NSString *)key;

- (NSString *)dp_stringForKey:(NSString *)key;
- (NSNumber *)dp_numberForKey:(NSString *)key;
- (NSArray *)dp_arrayForKey:(NSString *)key;
- (NSDictionary *)dp_dictionaryForKey:(NSString *)key;
- (NSData *)dp_dataForKey:(NSString *)key;
- (id)dp_objectValueForKey:(NSString *)key;

- (NSMutableString *)dp_mutableStringForKey:(NSString *)key;
- (NSMutableArray *)dp_mutableArrayForKey:(NSString *)key;
- (NSMutableDictionary *)dp_mutableDictionaryForKey:(NSString *)key;
- (NSMutableData *)dp_mutableDataForKey:(NSString *)key;
@end
