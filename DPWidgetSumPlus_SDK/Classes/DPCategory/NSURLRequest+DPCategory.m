//
//  NSURLRequest+DPCategory.m
//  DPWidgetSumPlusDemo
//
//  Created by yupeng xia on 2021/9/18.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

#import "NSURLRequest+DPCategory.h"

@implementation NSURLRequest (DPCategory)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host {
    
}
@end
