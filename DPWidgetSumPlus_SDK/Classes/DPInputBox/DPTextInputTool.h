//
//  DPTextInputTool.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPTextInputTool : NSObject
/**
 *  正则匹配
 *
 *  @param aText 当前验证文字
 *  @param aRegularStr 当前正则内容
 *  @return BOOL：YES 匹配，NO 不匹配
 *
 */
+ (BOOL)regularCheckText:(NSString *)aText regularStr:(NSString *)aRegularStr;

/**
 *  正则替换
 *
 *  @param aText 当前验证文字
 *  @param aReplacStr 将要替换的字符
 *  @param aRegularStr 当前正则内容
 *  @return NSString 替换后的文字
 *
 */
+ (NSString *)regularReplacText:(NSString *)aText replacStr:(NSString *)aReplacStr regularStr:(NSString *)aRegularStr;

///删除不可编码字符，编码格式：kCFStringEncodingGB_18030_2000
+ (NSString *)deleteUnableEncodeWithStr:(NSString *)aStr;

///字符串字节计算，编码：kCFStringEncodingGB_18030_2000
+ (NSUInteger)byteCountWithStr:(NSString *)aStr;
@end
