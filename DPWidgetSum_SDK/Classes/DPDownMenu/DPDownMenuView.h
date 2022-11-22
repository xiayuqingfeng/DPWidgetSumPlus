//
//  DPDownMenuView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DPDownMenuView;
///aType: 0 按钮点击，1 刷新数据
typedef void(^DPDownMenuViewButtonBlock)(DPDownMenuView *aObject, NSInteger aType);
typedef BOOL(^DPDownMenuViewIsTapBlock)(DPDownMenuView *aObject);

@interface DPDownMenuView : UIView
///选择回调
@property (nonatomic,  copy) DPDownMenuViewButtonBlock aTapBlock;
///文字显示显示框点击状态回调事件
@property (nonatomic,  copy) DPDownMenuViewIsTapBlock aTapEnabledBlock;

///右边icon 未点击状态
@property (nonatomic, strong) UIImage *arrowNImage;
///右边icon 已点击状态
@property (nonatomic, strong) UIImage *arrowSImage;

///左边边界间隙，默认 DP_FrameWidth(12)
@property (nonatomic, assign) CGFloat lrGap;
///字体大小，默认 DP_Font(15)
@property (nonatomic, strong) UIFont *textFont;
///菜单按钮参数数组
@property (nonatomic, strong) NSArray <NSDictionary <NSString *, NSString *>*>*dataArray;
///当前选择键值对 @{@"选择输出参数":@"显示参数"}
@property (nonatomic, strong) NSDictionary <NSString *, NSString *>*selectDic;
///菜单选择列表显示状态
@property (nonatomic, assign) BOOL menuHidden;

///aFrame: 不可为空，当前控件frame；aSuperView: 不可为空，当前控件父视图；aRootView:  可为空，当前控件“弹出按钮菜单”父视图；aSelectBlock: 可为空，当前控件“菜单按钮”点击事件回调；
+ (id)initWithSuperView:(UIView *)aSuperView rootView:(UIView *)aRootView selectBlock:(DPDownMenuViewButtonBlock)aSelectBlock;
@end
