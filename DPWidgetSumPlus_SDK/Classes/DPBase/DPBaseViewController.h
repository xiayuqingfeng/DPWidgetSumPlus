//
//  DPBaseViewController.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPUIBaseViewController.h"
#import "DPBaseContentView.h"
#import "DPDefaultView.h"
@class DPBaseViewController;

///返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
typedef BOOL (^ViewLifeCycleBlock)(DPBaseViewController *aObject, BOOL animated);

@interface DPBaseViewController : DPUIBaseViewController {
    
}
///控制器viewWillAppear生命周期block回调函数。返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
@property (nonatomic, copy) ViewLifeCycleBlock viewWillAppearBlock;
///控制器viewDidAppear生命周期block回调函数。返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
@property (nonatomic, copy) ViewLifeCycleBlock viewDidAppearBlock;
///控制器viewDidAppear生命周期block回调函数。返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
@property (nonatomic, copy) ViewLifeCycleBlock viewWillDisappearBlock;
///控制器viewDidDisappear生命周期block回调函数。返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
@property (nonatomic, copy) ViewLifeCycleBlock viewDidDisappearBlock;
///控制器viewDidLoad生命周期block回调函数。返回BOOL值, 为YES则停止基类中的判断逻辑, 为NO则继续使用基类中的判断逻辑.
@property (nonatomic, copy) ViewLifeCycleBlock viewDidLoadBlock;
///返回事件回调
@property (nonatomic, copy) void(^leftBackBtnActionBlock)(DPBaseViewController *aObject);

///上级控制器
@property (nonatomic, weak) UIViewController *fontController;

///导航栏
@property (nonatomic, strong) UIView *navBarView;
///导航栏 返回按钮
@property (nonatomic, strong) UIButton *leftBackBtn;
///导航栏 标题
@property (nonatomic, strong) UILabel *titleLabel;
///主视图(子视图超出区域，自动延伸显示区域，兼容小屏幕)，默认：为空，getter方法初始化
@property (nonatomic, strong) DPBaseContentView *contentView;

///导航栏是否显示，默认：NO 显示
@property (nonatomic, assign) BOOL isHiddenNavBarView;
///返回按钮是否显示，默认：NO 显示
@property (nonatomic, assign) BOOL isHiddenBackBtn;
/*
    主视图布局类型，默认值：0;
    0：contentView的frame为上下导航栏以外区域(navBarView与contentView重叠);
    1：contentView的frame为上下导航栏以外区域(navBarView不与contentView重叠);
 */
@property (nonatomic, assign) NSInteger contentLayoutType;

///导航栏左侧返回按钮点击事件
- (void)leftBackBtnAction:(id)sender;

///显示|隐藏默认视图
- (void)showDefaulWithSuperView:(UIView *)aSuperView useType:(NSInteger)aUseType dataCount:(NSInteger)aDataCount btnBlock:(DPDefaultViewButtonBlock)aBtnBlock;
/**
 *  显示|隐藏默认视图
 *
 *  @param aSuperView: 父视图，为空使用根视图（优先使用功能contentView，为空使用self.view）;
 *  @param aUseType: 显示样式，0 数据为空样式，1 网络请求失败样式;
 *  @param aTitle: 提示语，默认值：@"获取数据为空";
 *  @param aBtnTitle: 按钮文字，默认值：@"重新获取";
 *  @param aShowType: 1 只有提示语, 2 只有图片, 3 提示语+图片;
 *  @param aLayoutType: 1 内容整体靠上位置显示, 2 内容整体居中显示, 3 内容整体靠上（距离50）位置显;
 *  @param aDataCount: 数据长度，0 不显示，1 显示;
 *  @param aBtnBlock: 为nil不显示按钮;
 *
 */
- (void)showDefaulWithSuperView:(UIView *)aSuperView useType:(NSInteger)aUseType title:(NSString *)aTitle btnTitles:(NSArray <NSString *>*)aBtnTitles showType:(int)aShowType layoutType:(int)aLayoutType dataCount:(NSInteger)aDataCount btnBlock:(DPDefaultViewButtonBlock)aBtnBlock;
@end
