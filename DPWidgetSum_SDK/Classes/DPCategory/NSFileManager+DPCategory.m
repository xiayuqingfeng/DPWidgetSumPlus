//
//  NSFileManager+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "NSFileManager+DPCategory.h"
#import  <stdio.h>
#include <sys/xattr.h>
#import <SBJson/SBJson5.h>

@implementation NSFileManager (DPCategory)
///全局获取documentDirectory
static NSString *documentDirectory;
+ (NSString *)dp_documentDirectory{
    if(nil == documentDirectory || documentDirectory.length<=0){
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentDirectory = [[directoryPaths firstObject] copy];
    }
    return documentDirectory;
}

+ (void)dp_saveDic:(NSString *)fileName andSource:(NSDictionary *)source{
    NSString *path=[NSFileManager dp_documentAppendPath:fileName];
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithDictionary:source];
    NSArray * keys=dic.allKeys;
    for (NSString *key in keys) {
        if ([dic[key] isKindOfClass:[NSValue class]]) {
            [dic setObject:[dic[key] stringValue] forKey:key];
        }
    }
    [dic writeToFile:path atomically:YES];
}
+ (NSDictionary *)dp_readToDic:(NSString *)fileName{
    NSString *path=[NSFileManager dp_documentAppendPath:fileName];
    NSDictionary * dic=[NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
    
}
+ (void)dp_saveArr:(NSString *)fileName andSource:(NSMutableArray *)source {
    NSString *path=[NSFileManager dp_documentAppendPath:fileName];
    //    NSLog(@"path=%@",path);
    [source writeToFile:path atomically:YES];
}

+ (NSMutableArray *)readToArr:(NSString *)fileName{
    NSString *path=[NSFileManager dp_documentAppendPath:fileName];
    return [NSMutableArray arrayWithContentsOfFile:path];
}
+ (void)dp_saveStr:(NSString *)fileName andSource:(NSString *)source{
    NSString *path=[NSFileManager dp_documentAppendPath:fileName];
    NSData *data=[source dataUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:YES];
    });
}
+ (NSString *)dp_readToStr:(NSString *)fileName{
    NSString *path = [NSFileManager dp_fileExistsNoneAtDocumentFileName:fileName replaceBundleFile:fileName bundleFileType:nil];
    if (path==nil || path.length==0) {
        return nil;
    }
    NSData *data=[NSData dataWithContentsOfFile:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
+ (BOOL)dp_existFileAtFath:(NSString *)fileName{
    NSString *path=[NSFileManager dp_documentAppendPath:fileName];
    NSFileManager* fm=[NSFileManager defaultManager];
    return [fm fileExistsAtPath:path];
}
+ (NSString *)dp_documentAppendPath:(NSString *)path {
    NSString *documentPath = [self dp_documentDirectory];
    return [documentPath stringByAppendingPathComponent:path ];
}

+ (id)dp_readDictionaryFromPath:(NSString *)filePath {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    if(nil == dict || dict.allKeys.count < 1){
        NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

        __block NSDictionary *aDic = nil;
        SBJson5Parser *parser = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                aDic = (NSDictionary *)item;
            }
        } errorHandler:^(NSError *error) {
            NSLog(@"SBJson5Parser_error:%@", error);
        }];
        NSData *parserData = [string dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:parserData];

        if(nil != aDic && [aDic isKindOfClass:[NSDictionary class]]){
            dict = [NSMutableDictionary dictionaryWithDictionary:aDic];
        }
        return dict;
    }
    
    if(nil==dict||dict.allKeys.count<1) dict = [NSMutableDictionary dictionary];
    return dict;
}
+ (id)dp_readArrayFromPath:(NSString *)filePath {
    NSMutableArray * array = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    if(nil == array || array.count < 1){
        NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        __block NSArray *aArr = nil;
        SBJson5Parser *parser = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
            if ([item isKindOfClass:[NSArray class]]) {
                aArr = (NSArray *)item;
            }
        } errorHandler:^(NSError *error) {
            NSLog(@"SBJson5Parser_error:%@", error);
        }];
        NSData *parserData = [string dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:parserData];
        
        if(nil != aArr && [aArr isKindOfClass:[NSArray class]]){
            array = [NSMutableArray arrayWithArray:array];
        }
        return array;
    }
    
    if(nil==array||[array count]<=0) array = [NSMutableArray array];
    return array;
}
+ (id)dp_readDictionaryFromFile:(NSString *)fileName{
    NSString *path = [self dp_documentAppendPath:fileName];
    
    NSMutableDictionary * dict = [self dp_readDictionaryFromPath:path];
    if(nil==dict||dict.allKeys.count<1) dict = [NSMutableDictionary dictionary];
    return dict;
}
+ (id)dp_readArrayFromFile:(NSString *)fileName{
    NSString *path = [self dp_documentAppendPath:fileName];
    NSMutableArray* array = [NSMutableArray arrayWithContentsOfFile:path];
    if(nil==array||[array count]<=0) array = [NSMutableArray array];
    return array;
}

+ (id)dp_readDictionaryFromBundleFile:(NSString *)fileName ofType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSMutableDictionary *fileDict = [self dp_readDictionaryFromPath:path];
    if(nil==fileDict || [[fileDict allKeys] count]<=0){
        return @{};
    }
    return fileDict;
}
+ (id)dp_readArrayFromBundleFile:(NSString *)fileName ofType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSMutableArray *fileArray = [NSMutableArray arrayWithContentsOfFile:path];
    if(nil==fileArray || [fileArray count]<=0){
        return @[];
    }
    return fileArray;
}
+ (BOOL)dp_writeFile:(NSString *)fileName data:(id)data{
    NSString *documentDirectory = [self dp_documentDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    BOOL res = [data writeToFile:path atomically:YES];
    if (!res) {
        NSLog(@"write to file failed:%@", path);
    }
    return res;
}

+ (BOOL)dp_writeFile:(NSString *)fileName data:(id)data encoding:(NSStringEncoding)encode{
    NSMutableData *writer = [NSMutableData data];
    [writer appendData: [data dataUsingEncoding:encode]];
    return [self dp_writeFile:fileName data:writer];
}

+ (BOOL)dp_fileExistsRemoveAtPath:(NSString *)path {
    NSFileManager* fileManager= [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return [fileManager removeItemAtPath:path error:nil];
    }
    return YES;
}

+ (BOOL)dp_fileExistsRemoveAtFileName:(NSString *)fileName {
    NSString *documentDirectory = [self dp_documentDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return [fileManager removeItemAtPath:path error:nil];
    }
    return YES;
}

+ (id)dp_readJsonDictionaryFileFromBundleFile:(NSString *)fileName ofType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSDictionary *fileDict = [self dp_jsonDictionaryForPath:path];
    if(nil==fileDict || [[fileDict allKeys] count]<=0){
        return @{};
    }
    return fileDict;
}
+ (id)dp_readJsonArrayFileFromBundleFile:(NSString *)fileName ofType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSArray *fileArray = [self dp_jsonArrayForPath:path];;
    if(nil==fileArray || [fileArray count]<=0){
        return @[];
    }
    return fileArray;
}
+ (NSString *)dp_fileExistsNoneAtDocumentFileName:(NSString *)fileName replaceBundleFile:(NSString *)bundleFile bundleFileType:(NSString *)bundleFileType{
    NSString *path = [NSFileManager dp_documentAppendPath:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        path = [[NSBundle mainBundle] pathForResource:bundleFile ofType:bundleFileType];
    }
    return path;
}
+ (NSArray *)dp_fileOfArrayNoDocumentFileName:(NSString *)fileName replaceBundleFile:(NSString *)bundleFile bundleFileType:(NSString *)bundleFileType{
    NSString *path = [NSFileManager dp_documentAppendPath:fileName];
    BOOL isDocumentPath = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!isDocumentPath){
        path = [[NSBundle mainBundle] pathForResource:bundleFile ofType:bundleFileType];
    }
    
    if(nil != path && path.length>0){
        return [self dp_readArrayFromPath:path];
    }
    return @[];
}
+ (NSDictionary *)dp_fileOfDictionaryNoDocumentFileName:(NSString *)fileName replaceBundleFile:(NSString *)bundleFile bundleFileType:(NSString *)bundleFileType{
    NSString *path = [NSFileManager dp_documentAppendPath:fileName];
    BOOL isDocumentPath = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!isDocumentPath){
        path = [[NSBundle mainBundle] pathForResource:bundleFile ofType:bundleFileType];
    }
    
    if(nil != path && path.length>0){
        return [self dp_readDictionaryFromPath:path];
    }
    return @{};
}

+ (NSString *)dp_jsonStringForPath:(NSString *)path {
    NSData *oldData = [[NSFileManager defaultManager] contentsAtPath:path];
    NSString *str = [[NSString alloc] initWithData:oldData encoding:NSUTF8StringEncoding];
    return str;
}
+ (NSString *)dp_jsonStringForFileName:(NSString *)fileName {
    NSString *documentDirectory = [self dp_documentDirectory];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    
    NSData *oldData = [[NSFileManager defaultManager] contentsAtPath:path];
    NSString *str = [[NSString alloc] initWithData:oldData encoding:NSUTF8StringEncoding];
    return str;
}
+ (NSDictionary *)dp_jsonDictionaryForBundleFile:(NSString *)fileName ofType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    return [NSFileManager dp_jsonDictionaryForPath:path];
}
+ (NSDictionary *)dp_jsonDictionaryForPath:(NSString *)path {
    NSString *str = [self dp_jsonStringForPath:path];
    if(nil == str|| str.length<=0){
        return @{};
    }
    
    __block NSDictionary *fileDict = nil;
    SBJson5Parser *parser = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            fileDict = (NSDictionary *)item;
        }
    } errorHandler:^(NSError *error) {
        NSLog(@"SBJson5Parser_error:%@", error);
    }];
    NSData *parserData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:parserData];

    if(nil==fileDict || [[fileDict allKeys] count]<=0){
        return @{};
    }
    return fileDict;
}
+ (NSDictionary *)dp_jsonDictionaryForDocumentFile:(NSString *)fileName{
    NSString *path = [self dp_documentAppendPath:fileName];
    return [self dp_jsonDictionaryForPath:path];
}


+ (NSArray *)dp_jsonArrayForBundleFile:(NSString *)fileName ofType:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    return [NSFileManager dp_jsonArrayForPath:path];
}
+ (NSArray *)dp_jsonArrayForPath:(NSString *)path {
    NSString *str = [self dp_jsonStringForPath:path];
    if(nil == str|| str.length<=0){
        return @[];
    }
    
    __block NSArray *fileArray = nil;
    SBJson5Parser *parser = [SBJson5Parser parserWithBlock:^(id item, BOOL *stop) {
        if ([item isKindOfClass:[NSArray class]]) {
            fileArray = (NSArray *)item;
        }
    } errorHandler:^(NSError *error) {
        NSLog(@"SBJson5Parser_error:%@", error);
    }];
    NSData *parserData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [parser parse:parserData];
    
    if(nil==fileArray || [fileArray count]<=0){
        return @[];
    }
    return fileArray;
}
+ (NSArray *)dp_jsonArrayForDocumentFile:(NSString *)fileName{
    NSString *path = [self dp_documentAppendPath:fileName];
    return [self dp_jsonArrayForPath:path];
}


//属性处理
//合并操作

//为文件增加一个扩展属性
+ (BOOL)dp_fileExtendedAtributeForPath:(NSString *)path key:(NSString *)key value:(NSData *)value{
    ssize_t writeOk = setxattr([path fileSystemRepresentation],
                               [key UTF8String],
                               [value bytes],
                               [value length],
                               0,
                               0);
    return writeOk==0?YES:NO;
}
//读取文件扩展属性
+ (NSData *)fileExtendedAtributeFromPath:(NSString *)path key:(NSString *)key{
    NSData * nullData = [NSData data];
    
    ssize_t readlen = 1024;
    do {
        char buffer[readlen];
        bzero(buffer, sizeof(buffer));
        size_t leng = sizeof(buffer);
        readlen = getxattr([path fileSystemRepresentation],
                           [key UTF8String],
                           buffer,
                           leng,
                           0,
                           0);
        if (readlen < 0)                      return nullData;
        else if (readlen > sizeof(buffer))    continue;
        else
        {
            return [NSData dataWithBytes:buffer length:readlen];
        }
    } while (YES);
    
    return nullData;
}

+ (BOOL)dp_fileName:(NSString *)fileName fileExtendedAtribute:(NSString *)fileExtendedAtribute value:(NSNumber *)value{
    int valueLL= [value intValue];
    NSString *path = [NSFileManager dp_documentAppendPath:fileName];
    BOOL sucess = [NSFileManager dp_fileExtendedAtributeForPath:path key:fileExtendedAtribute value:[NSData dataWithBytes:&valueLL length:sizeof(valueLL)]];
    return sucess;
}

+ (NSNumber *)dp_fileExtendedAtributeValueByFileName:(NSString *)fileName fileExtendedAtribute:(NSString *)fileExtendedAtribute{
    NSString *path = [NSFileManager dp_documentAppendPath:fileName];
    NSDictionary * sizeDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    NSData * numData = [[sizeDict objectForKey:@"NSFileExtendedAttributes"] objectForKey:fileExtendedAtribute];
    NSInteger rev = 0;
    [numData getBytes:&rev length:numData.length];
    NSNumber * num = @(rev);
    return num;
}
@end
