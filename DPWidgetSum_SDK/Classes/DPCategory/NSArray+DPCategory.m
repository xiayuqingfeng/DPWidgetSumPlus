//
//  NSArray+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "NSArray+DPCategory.h"
#import "DPWidgetSum.h"

@implementation NSArray (DPCategory)
//防崩溃，扩展系统函数 objectAtIndex:
- (id)dp_objectAtIndex:(NSInteger)index {
    id retObject = nil;
    if(nil != self && self.count>0 && index>=0 ){
        NSInteger count = self.count;
        if (index<count) {
            retObject = [self objectAtIndex:index];
        }
    }
    return retObject;
}
//是否包含相同字符串，不判断指针
- (BOOL)dp_containsString:(NSString *)aString {
    for (NSString *tempStr in self) {
        if([tempStr isEqualToString:aString]){
            return YES;
        }
    }
    return NO;
}
@end
