//
//  NSData+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "NSData+DPCategory.h"
#import "DPWidgetSumPlus.h"
#import "zlib.h"

//取反加密
#define SDK_REVERSE_IV_KEY @"ABCDEFJHIJKLMNO0123456789^abcd()*&<efghijklmnopqrstuvwxyz!$%PQRSTUVWXYZ"

@implementation NSData (DPCategory)
///gzip压缩
+ (NSData *)gzipDeflate:(NSData *)data{
    if ([data length] == 0) {
        return data;
    }
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[data bytes];
    strm.avail_in = (uInt)[data length];
    
    // Compresssion Levels:
    // Z_NO_COMPRESSION
    // Z_BEST_SPEED
    // Z_BEST_COMPRESSION
    // Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) {
        return nil;
    }
    
    // 16K chunks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do {
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)[compressed length] - (uInt)strm.total_out;
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}

///gzip解压
+ (NSData *)gzipInflate:(NSData*)data{
    if ([data length] == 0) {
        return data;
    }
    
    unsigned full_length = (uInt)[data length];
    unsigned half_length = (uInt)[data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = (uInt)[data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) {
        return nil;
    }
    
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)[decompressed length] - (uInt)strm.total_out;
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) {
        return nil;
    }
    
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}

///取反加密
+ (NSString *)reverseEncrypt:(NSString*)data key:(NSString*)aKey{
    if (aKey.length < 1) {
        aKey = SDK_REVERSE_IV_KEY;
    }
    
    char  b[600];
    const char * dataByte  = [data UTF8String];
    const char * keyByte = [aKey UTF8String];
    
    size_t len = strlen(dataByte);
    size_t lenk = strlen(keyByte);
    
    memset(b,0,sizeof(b));
    strcpy(b,dataByte);
    
    for (int i =0; i<len; i++) {
        for (int j =0; j<lenk; j++) {
            b[i] = (char) (b[i]^keyByte[j]);
        }
    }
    
    NSString *str = [[NSString alloc] initWithBytes:b length:len encoding:NSUTF8StringEncoding];
    return str;
}
@end
