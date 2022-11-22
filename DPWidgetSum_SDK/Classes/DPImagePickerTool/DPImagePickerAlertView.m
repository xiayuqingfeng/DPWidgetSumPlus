//
//  DPImagePickerAlertView.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPImagePickerAlertView.h"
#import "DPWidgetSum.h"
#import "DPImagePickerTool.h"

@interface DPImagePickerAlertView () {
    
}
@end

@implementation DPImagePickerAlertView
+ (void)showViewWithDelegate:(NSObject *)aDelegate title:(NSString *)aTitle completion:(void(^)(UIImage *image, NSError *error))completion {
    if (aTitle == nil || aTitle.length < 1) {
        aTitle = @"上传图片";
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:aTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aOneBtn = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [DPImagePickerTool pickerWithDelegate:aDelegate pickerType:0 pickerSet:0 completion:completion];
    }];
    [alertVc addAction:aOneBtn];
    
    UIAlertAction *aTowBtn = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [DPImagePickerTool pickerWithDelegate:aDelegate pickerType:1 pickerSet:0 completion:completion];
    }];
    [alertVc addAction:aTowBtn];
    
    UIAlertAction *aCancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:aCancelBtn];
    [(UIViewController *)aDelegate presentViewController:alertVc animated:YES completion:nil];
}
@end
