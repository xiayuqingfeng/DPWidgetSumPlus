//
//  NSObject+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (DPCategory)
///所有NSString类型变量为nil时，设置值为@""
- (void)dp_setDefaultValueForAllStringProperty;
///重置所有NSString、NSDictionary、NSMutableArray……类型变量为空数据
- (void)dp_clearValueForAllStringProperty;
@end

@interface NSObject (Runtime)
///标记 id 数据
@property (nonatomic, strong) id dpIndentObject;
///标记 UIButton 数据
@property (nonatomic, strong) UIButton *dpIndentButton;
///标记 NSDictionary 数据
@property (nonatomic, strong) NSDictionary *dpIndentDictionary;
///标记 NSArray 数据
@property (nonatomic, strong) NSArray *dpIndentNSArray;
///标记 NSString 数据
@property (nonatomic, strong) NSString *dpIndentString;
///标记 NSIndexPath 数据
@property (nonatomic, strong) NSIndexPath *dpIndentIndexPath;
///标记 CGFloat 数据
@property (nonatomic, assign) CGFloat dpIndentFloat;
///标记 NSInteger 数据
@property (nonatomic, assign) NSInteger dpIndentInteger;
///标记 BOOL 数据
@property (nonatomic, assign) BOOL dpIndentBool;
@end

@interface NSObject (FaultTolerance)
+ (id)dp_numberOrNilOfData:(id)data;
+ (BOOL)dp_BOOLOrNilOfData:(id)data;
+ (int)dp_intOrNilOfData:(id)data;
+ (NSInteger)dp_integerOrNilOfData:(id)data;
+ (CGFloat)dp_floatOrNilOfData:(id)data;
+ (double)dp_doubleOrNilOfData:(id)data;
+ (NSArray *)dp_arrayOrNilOfData:(id)data;
+ (NSMutableArray *)dp_arrayMutabledOrNilOfData:(id)data;
+ (NSDictionary *)dp_dictionaryOrNilOfData:(id)data;
+ (id)dp_dataOrNilOfData:(id)data;
+ (id)dp_stringOrNilOfData:(id)data;
@end
