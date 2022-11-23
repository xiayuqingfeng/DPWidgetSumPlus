//
//  DPImagePickerTool.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPImagePickerTool : NSObject
/**
 *  相册、相机控件使用
 *
 *  @param aDelegate 当前持有者
 *  @param aPickerType 使用对象：0 相机，1 相册
 *  @param aPickerStyle 相机、相册配置：0 默认配置，1 ……
 *  @param completion 回调事件
 *
 */
+ (id)pickerWithDelegate:(NSObject *)aDelegate pickerType:(NSInteger)aPickerType pickerSet:(NSInteger)aPickerSet completion:(void(^)(UIImage *image, NSError *error))completion;
@end
