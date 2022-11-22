//
//  ViewController.m
//  test
//
//  Created by xiayupeng on 2018/12/17.
//  Copyright © 2018 yupeng xia. All rights reserved.
//

#import "ViewControllerFive.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DPWidgetSum.h"
#import "DPImagePickerAlertView.h"
#import "DPImagePickerTool.h"

@interface ViewControllerFive () {
    
}
@property (nonatomic, strong) UIImageView *aImageView;
@end

@implementation ViewControllerFive
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBarView = YES;
    self.isAutorotateBase = YES;
    
    self.aImageView = [[UIImageView alloc] init];
    _aImageView.frame = self.contentView.bounds;
    _aImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _aImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_aImageView];
    
    dp_arc_block(self);
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(0, DP_FrameHeight(100), 200, 40);
    msgBtn.dp_centerX = self.contentView.dp_width/2;
    msgBtn.backgroundColor = [UIColor orangeColor];
    [msgBtn setTitle:@"弹框选择图片" forState:UIControlStateNormal];
    [[msgBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [DPImagePickerAlertView showViewWithDelegate:self title:@"选择图片" completion:^(UIImage *image, NSError *error) {
            weak_self.aImageView.image = image;
        }];
    }];
    [self.contentView addSubview:msgBtn];
    
    UIButton *msgBtnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtnOne.frame = CGRectMake(0, msgBtn.dp_yMax+DP_FrameHeight(10), 200, 40);
    msgBtnOne.dp_centerX = self.contentView.dp_width/2;
    msgBtnOne.backgroundColor = [UIColor orangeColor];
    [msgBtnOne setTitle:@"相册选择图片" forState:UIControlStateNormal];
    [[msgBtnOne rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [DPImagePickerTool pickerWithDelegate:self pickerType:1 pickerSet:0 completion:^(UIImage *image, NSError *error) {
            weak_self.aImageView.image = image;
        }];
    }];
    [self.contentView addSubview:msgBtnOne];
    
    UIButton *msgBtnTow = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtnTow.frame = CGRectMake(0, msgBtnOne.dp_yMax+DP_FrameHeight(10), 200, 40);
    msgBtnTow.dp_centerX = self.contentView.dp_width/2;
    msgBtnTow.backgroundColor = [UIColor orangeColor];
    [msgBtnTow setTitle:@"相机拍摄图片" forState:UIControlStateNormal];
    [[msgBtnTow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [DPImagePickerTool pickerWithDelegate:self pickerType:0 pickerSet:0 completion:^(UIImage *image, NSError *error) {
            weak_self.aImageView.image = image;
        }];
    }];
    [self.contentView addSubview:msgBtnTow];
}
@end
