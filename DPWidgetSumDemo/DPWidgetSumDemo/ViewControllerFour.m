//
//  ViewController.m
//  test
//
//  Created by xiayupeng on 2018/12/17.
//  Copyright © 2018 yupeng xia. All rights reserved.
//

#import "ViewControllerFour.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DPWidgetSum.h"
#import "DPDefaultView.h"
#import "DPShareView.h"

@interface ViewControllerFour () {

}
@end

@implementation ViewControllerFour
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBarView = YES;
    
    dp_arc_block(self);
    UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultBtn.frame = CGRectMake(0, DP_FrameHeight(10), self.contentView.dp_width, 40);
    defaultBtn.backgroundColor = [UIColor purpleColor];
    [defaultBtn setTitle:@"默认显示框-DPDefaultView" forState:UIControlStateNormal];
    [[defaultBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        [weak_self showDefaulWithSuperView:nil useType:1 dataCount:0 btnBlock:^(DPDefaultView *aObject, NSInteger selectIndex) {
//            [aObject hiddenDefaulTSuperView];
//        }];
        
        DPShareDataObject *shareObject = [[DPShareDataObject alloc]init];
        shareObject.title = @"asdfasdf";
        shareObject.text = @"asdfasdf";
        shareObject.url = @"asdfasdf";
        shareObject.sinaText = @"asdfasdf";
        shareObject.moreSelectType = @"123456";
        
        [DPShareView createShareView:self.contentView shareDataObject:shareObject contentType:DPShareContentTypeDefault currentVc:nil platformBack:^BOOL(DPShareView *aObject, DPSharePlatformType platformType) {
            return YES;
        }  callBack:^(DPShareView *aObject, DPSharePlatformType platformType, id data, NSError *error) {
           
        }];
    }];
    [self.contentView addSubview:defaultBtn];;
}
@end
