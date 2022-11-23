//
//  NSData+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DPCategory)
///gzip压缩
+ (NSData *)gzipDeflate:(NSData *)data;
///gzip解压
+ (NSData *)gzipInflate:(NSData*)data;

///取反加密
+ (NSString *)reverseEncrypt:(NSString*)data key:(NSString*)aKey;
@end
