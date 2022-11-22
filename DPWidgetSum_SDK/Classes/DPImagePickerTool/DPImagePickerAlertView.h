//
//  DPImagePickerAlertView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPImagePickerAlertView : NSObject
/**
 *  相册、相机选择弹框
 *
 *  @param aDelegate 当前持有者
 *  @param aTitle 弹框标题
 *  @param completion 回调事件
 *
 */
+ (void)showViewWithDelegate:(NSObject *)aDelegate title:(NSString *)aTitle completion:(void(^)(UIImage *image, NSError *error))completion;
@end
