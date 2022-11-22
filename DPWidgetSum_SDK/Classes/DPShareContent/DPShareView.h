//
//  DPShareView.h
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPShareContent.h"
#import "DPShareBtn.h"
@class DPShareView;
@class DPShareBtn;

typedef BOOL(^ShareViewPlatformBlock)(DPShareView *aObject, DPSharePlatformType platformType);
typedef void(^ShareViewContentBlock)(DPShareView *aObject, DPSharePlatformType platformType, id data, NSError *error);

@interface DPShareView : UIView
///分享弹框按钮点击回调事件
@property (nonatomic, strong) ShareViewPlatformBlock platformBack;
///分享结束回调事件
@property (nonatomic, strong) ShareViewContentBlock callBack;

///当前控制器
@property (nonatomic, weak) UIViewController *currentVc;
///弹框样式：0 屏幕底部弹出样式，1 屏幕中心弹出样式；
@property (nonatomic, assign) NSInteger shareViewStyle;
///分享内容载体
@property (nonatomic, strong) DPShareDataObject *dataObject;
///分享内容格式
@property (nonatomic, assign) ShareViewContentType contentType;

///第三方分享弹框: aSuperView 弹框父视图；aDataObject 分享内容；aContentType 分享类型(图、文搭配类型)；aCurrentVc 当前控制器；aPlatformBack  分享弹框按钮点击回调事件；aCallBack 分享结束回调事件；
+ (DPShareView *)createShareView:(UIView *)aSuperView shareDataObject:(DPShareDataObject *)aDataObject contentType:(ShareViewContentType)aContentType currentVc:(UIViewController *)aCurrentVc platformBack:(ShareViewPlatformBlock)aPlatformBack callBack:(ShareViewContentBlock)aCallBack;

///第三方分享弹框: aSuperView 弹框父视图；aDataObject 分享内容；aContentType 分享类型(图、文搭配类型)；aCurrentVc 当前控制器；aStyle：0 屏幕底部弹出样式，1 屏幕中心弹出样式；aPlatformBack  分享弹框按钮点击回调事件；aCallBack 分享结束回调事件；
+ (DPShareView *)createShareView:(UIView *)aSuperView shareDataObject:(DPShareDataObject *)aDataObject contentType:(ShareViewContentType)aContentType currentVc:(UIViewController *)aCurrentVc style:(NSInteger)aStyle platformBack:(ShareViewPlatformBlock)aPlatformBack callBack:(ShareViewContentBlock)aCallBack;

///直接分享，无弹框；aPlatformType 分享平台；dataObject 分享内容；contentType 分享类型(图、文搭配类型)；aCurrentVc 当前控制器；aCallBack 分享结束回调事件；
+ (void)directShareForPlatformType:(DPSharePlatformType)aPlatformType shareDataObject:(DPShareDataObject *)aDataObject contentType:(ShareViewContentType)aContentType currentVc:(UIViewController *)aCurrentVc callBack:(ShareViewContentBlock)aCallBack;

//动画打开弹框
- (void)shareViewOpen;
//动画关闭弹框
- (void)shareViewClose;
@end
