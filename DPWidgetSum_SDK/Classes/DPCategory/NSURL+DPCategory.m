//
//  NSURL+DPCategory.m
//  DPWidgetSumDemo
//
//  Created by yupeng xia on 2021/9/18.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

#import "NSURL+DPCategory.h"
#import "DPWidgetSum.h"

@implementation NSURL (DPCategory)
///包含中文，进行编码
+ (NSURL *)dp_urlEncodedString:(NSString *)urlString {
    if (urlString.length < 1) {
        return [NSURL URLWithString:@""];
    }
    return [NSURL URLWithString:[urlString dp_urlEncodedString]];
}
@end
