//
//  NSArray+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DPCategory)
///防崩溃，扩展系统函数 objectAtIndex:
- (id)dp_objectAtIndex:(NSInteger)index;
///是否包含相同字符串，不判断指针
- (BOOL)dp_containsString:(NSString *)aString;
@end
