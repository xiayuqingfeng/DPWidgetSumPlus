//
//  NSURL+DPCategory.h
//  DPWidgetSumDemo
//
//  Created by yupeng xia on 2021/9/18.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (DPCategory)
///包含中文，进行编码
+ (NSURL *)dp_urlEncodedString:(NSString *)urlString;
@end
