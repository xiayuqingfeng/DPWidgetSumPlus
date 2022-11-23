//
//  NSURLRequest+DPCategory.h
//  DPWidgetSumPlusDemo
//
//  Created by yupeng xia on 2021/9/18.
//  Copyright © 2021 yupeng xia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (DPCategory)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end
