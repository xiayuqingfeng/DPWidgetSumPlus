//
//  SUNSlideSwitchView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPTabMenuButton.h"
#import "DPTabMenuBarContent.h"
#import "DPTabMenuBarAttribute.h"
@class DPTabMenuBarView;

@protocol DPTabMenuBarViewDelegate <NSObject>
@required
///获取菜单导航栏配置参数实体
- (DPTabMenuBarAttribute *)attributeOfTab:(DPTabMenuBarView *)view attribute:(DPTabMenuBarAttribute *)aAttribute;
///获取菜单导航栏显示内容实体
- (DPTabMenuBarContent *)slideSwitchView:(DPTabMenuBarView *)view content:(DPTabMenuBarContent *)aContent viewOfTab:(NSInteger)index;
@optional
///菜单选择、主内容手势滑动回调代理
- (void)slideSwitchView:(DPTabMenuBarView *)view content:(DPTabMenuBarContent *)aContent viewOldIndex:(NSInteger)oldIndex viewIndex:(NSInteger)index;
///滑动左边界时传递手势回调代理
- (void)slideSwitchView:(DPTabMenuBarView *)view panLeftEdge:(UIPanGestureRecognizer*)panParam;
///滑动右边界时传递手势回调代理
- (void)slideSwitchView:(DPTabMenuBarView *)view panRightEdge:(UIPanGestureRecognizer*)panParam;
///跳转前判断是否可以跳转
- (BOOL)slideSwitchViewForButtonEanble:(DPTabMenuBarView *)view viewIndex:(NSInteger)index;
@end

@interface DPTabMenuBarView : UIView<UIScrollViewDelegate>
///菜单导航栏
@property (nonatomic, strong, readonly) DPTabMenuBarAttribute *aAttribute;
///主视图数组
@property (nonatomic, strong, readonly) NSMutableArray <DPTabMenuBarContent *>*contentArray;
///获取当前菜单导航栏选择位置内容载体
@property (nonatomic, strong, readonly) DPTabMenuBarContent *selectContent;
///获取当前菜单导航栏选择位置，修改当前菜单导航栏选择位置，默认值：0
@property (nonatomic, assign) NSInteger selectIndex;

- (id)initWithFrame:(CGRect)frame delegate:(id<DPTabMenuBarViewDelegate>)aDelegate;
///创建加载内容, 刷新加载内容
- (void)reloadContentView;
@end
