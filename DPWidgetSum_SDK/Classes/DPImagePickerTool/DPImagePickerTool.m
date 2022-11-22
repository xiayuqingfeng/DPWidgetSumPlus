//
//  DPImagePickerTool.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPImagePickerTool.h"
#import "DPWidgetSum.h"
#import "DPPermissionsTool.h"
#import "DPMessageAlertView.h"

@interface DPImagePickerTool ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
}
@property (nonatomic, weak) NSObject *delegate;
@property (nonatomic, assign) NSInteger pickerType;
@property (nonatomic, assign) NSInteger pickerSet;
@property (nonatomic, copy) void(^currentBlock)(UIImage *image, NSError *error);
@end

@implementation DPImagePickerTool
- (void)dealloc {
    if (self.currentBlock) {
        self.currentBlock = nil;
    }
}
+ (id)pickerWithDelegate:(NSObject *)aDelegate pickerType:(NSInteger)aPickerType pickerSet:(NSInteger)aPickerSet completion:(void(^)(UIImage *image, NSError *error))completion {
    DPImagePickerTool *aTool = [[DPImagePickerTool alloc] init];
    if (aTool) {
        aTool.delegate = aDelegate;
        aTool.pickerType = aPickerType;
        aTool.pickerSet = aPickerSet;
        aTool.currentBlock = completion;
        
        //当前对象没有持有者，指定持有者，禁止被释放
        aTool.delegate.dpIndentObject = aTool;
        
        dp_arc_block(aTool);

        if (aPickerType == 0) {
            [DPPermissionsTool isOpenCaptureDeviceServiceWithBlock:^(BOOL isOpen) {
                if (!isOpen) {
                    [DPAlertView showDPMessageAlertViewForTitle:nil content:@"您没有开启相机权限，开启后即可拍照" buttonTitles:@[@"稍后开启", @"去开启权限"] buttonBlock:^BOOL(DPMessageAlertView *aObject, NSInteger tapIndex) {
                        if (tapIndex == 1) {
                            [DPPermissionsTool openApplicationSettingsWithBlock:nil];
                        }
                        return YES;
                    }];
                }else {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = aTool;
                    if (weak_aTool.pickerSet == 0) {
                        picker.allowsEditing = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
                        picker.showsCameraControls = YES;
                        //设置使用后置摄像头，可以使用前置摄像头
                        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                        //闪光灯
                        picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                        picker.modalPresentationStyle = UIModalPresentationFullScreen;
                    }
                    [(UIViewController *)weak_aTool.delegate presentViewController:picker animated:YES completion:nil];
                }
            }];
        }else if (aPickerType == 1) {
            [DPPermissionsTool isOpenAlbumServiceWithBlock:^(BOOL isOpen) {
                if (!isOpen) {
                    [DPAlertView showDPMessageAlertViewForTitle:nil content:@"您没有开启相册权限，开启后即可查看相册图片" buttonTitles:@[@"稍后开启", @"去开启权限"] buttonBlock:^BOOL(DPMessageAlertView *aObject, NSInteger tapIndex) {
                        if (tapIndex == 1) {
                            [DPPermissionsTool openApplicationSettingsWithBlock:nil];
                        }
                        return YES;
                    }];
                }else {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = weak_aTool;
                    if (weak_aTool.pickerSet == 0) {
                        picker.allowsEditing = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        picker.modalPresentationStyle = UIModalPresentationFullScreen;
                    }
                    [(UIViewController *)weak_aTool.delegate presentViewController:picker animated:YES completion:nil];
                }
            }];
        }
    }
    return aTool;
}

#pragma mark <--------------UIImagePickerControllerDelegate-------------->
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    dp_arc_block(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weak_self.currentBlock) {
            weak_self.currentBlock(image, nil);
        }
        //主动释放当前对象持有者
        weak_self.delegate.dpIndentObject = nil;
    }];
}
@end
