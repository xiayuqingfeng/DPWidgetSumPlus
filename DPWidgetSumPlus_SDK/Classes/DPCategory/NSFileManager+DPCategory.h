//
//  NSFileManager+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (DPCategory)
+ (void)dp_saveDic:(NSString *)fileName andSource:(NSDictionary *)source;
+ (NSDictionary *)dp_readToDic:(NSString *)fileName;
+ (void)dp_saveArr:(NSString *)fileName andSource:(NSMutableArray *)source;
+ (NSMutableArray *)readToArr:(NSString *)fileName;
+ (void)dp_saveStr:(NSString *)fileName andSource:(NSString *)source;
+ (NSString *)dp_readToStr:(NSString *)fileName;
+ (BOOL)dp_existFileAtFath:(NSString *)fileName;
///获取基本的沙盒文件目录Documents
+ (NSString *)dp_documentDirectory;
///Documents追加目录
+ (NSString *)dp_documentAppendPath:(NSString *)path;

///[所有读取文件must] 读取dict从沙盒 Or Bundle 文件Path
+ (id)dp_readDictionaryFromPath:(NSString *)filePath;

///[所有读取文件must] 读取Array从沙盒 Or Bundle 文件Path
+ (id)dp_readArrayFromPath:(NSString *)filePath;

///读取dict从沙盒Plist文件Name
+ (id)dp_readDictionaryFromFile:(NSString *)fileName;
///读取dict从沙盒Plist文件Name
+ (id)dp_readArrayFromFile:(NSString *)fileName;

///从Bundle读取Dictionary从plist文件名称
+ (id)dp_readDictionaryFromBundleFile:(NSString *)fileName ofType:(NSString *)type;
///从Bundle读取Array从plist文件名称
+ (id)dp_readArrayFromBundleFile:(NSString *)fileName ofType:(NSString *)type;
///文件写入沙盒
+ (BOOL)dp_writeFile:(NSString *)fileName data:(id)data;
///文件写入沙盒+格式
+ (BOOL)dp_writeFile:(NSString *)fileName data:(id)data encoding:(NSStringEncoding)encode;
///文件删除，根据路径
+ (BOOL)dp_fileExistsRemoveAtPath:(NSString *)path;
///文件删除，根据文件名
+ (BOOL)dp_fileExistsRemoveAtFileName:(NSString *)fileName;
///读取text的json的Dictionary从Bundle文件
+ (id)dp_readJsonDictionaryFileFromBundleFile:(NSString *)fileName ofType:(NSString *)type;
///读取text的json的Array从Bundle文件
+ (id)dp_readJsonArrayFileFromBundleFile:(NSString *)fileName ofType:(NSString *)type;

///文件如果在沙盒FileName不存在就替换为Bundle文件的path
+ (NSString *)dp_fileExistsNoneAtDocumentFileName:(NSString *)fileName replaceBundleFile:(NSString *)bundleFile bundleFileType:(NSString *)bundleFileType;
///文件如果在沙盒FileName不存在就替换为Bundle文件的path
///获取plist_Array
+ (NSArray *)dp_fileOfArrayNoDocumentFileName:(NSString *)fileName replaceBundleFile:(NSString *)bundleFile bundleFileType:(NSString *)bundleFileType;
///文件如果在沙盒FileName不存在就替换为Bundle文件的path
///获取plist_Dictionary
+ (NSDictionary *)dp_fileOfDictionaryNoDocumentFileName:(NSString *)fileName replaceBundleFile:(NSString *)bundleFile bundleFileType:(NSString *)bundleFileType;


///读取text的json的String从path
+ (NSString *)dp_jsonStringForPath:(NSString *)path;
///读取text的json的String从fileName
+ (NSString *)dp_jsonStringForFileName:(NSString *)fileName;
///读取text的json的Dictionary从BundlePath
+ (NSDictionary *)dp_jsonDictionaryForBundleFile:(NSString *)fileName ofType:(NSString *)type;
///读取text的json的Dictionary从Path
+ (NSDictionary *)dp_jsonDictionaryForPath:(NSString *)path;
///读取text的json的Dictionary从FileName
+ (NSDictionary *)dp_jsonDictionaryForDocumentFile:(NSString *)fileName;

///读取text的json的Array从BundlePath
+ (NSArray *)dp_jsonArrayForBundleFile:(NSString *)fileName ofType:(NSString *)type;
///读取text的json的Array从Path
+ (NSArray *)dp_jsonArrayForPath:(NSString *)path;
///读取text的json的Array从FileName
+ (NSArray *)dp_jsonArrayForDocumentFile:(NSString *)fileName;

///设置本地文档的 滚动Value值
+ (BOOL)dp_fileName:(NSString *)fileName fileExtendedAtribute:(NSString *)fileExtendedAtribute value:(NSNumber *)value;

///获取本地文档的 滚动Value值
+ (NSNumber *)dp_fileExtendedAtributeValueByFileName:(NSString *)fileName fileExtendedAtribute:(NSString *)fileExtendedAtribute;
@end
