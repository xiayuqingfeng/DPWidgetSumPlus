//
//  DPDefaultView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 zcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DPDefaultView;

typedef void (^DPDefaultViewButtonBlock)(DPDefaultView *aObject, NSInteger selectIndex);

@interface DPDefaultView : UIView
/**
 *  显示默认视图，提示语+图片，内容整体居中显示
 *
 *  @param aSuperView: 父视图;
 *  @param aTopImage: 顶部图片，默认值：dp_BundleImageNamed(@"dp_no_data.png");
 *  @param aTitle: 提示语，默认值：@"获取数据为空";
 *  @param aBtnTitles:  按钮文字数组，默认值：@[@"重新获取"];
 *  @param aBtnBlock: 为nil不显示按钮;
 *
 */
+ (id)showDefaulWithSuperView:(UIView *)aSuperView topImage:(UIImage *)aTopImage title:(NSString *)aTitle btnTitles:(NSArray <NSString *>*)aBtnTitles btnBlock:(DPDefaultViewButtonBlock)aBtnBlock;

/**
 *  显示默认视图
 *
 *  @param aSuperView: 父视图;
 *  @param aTopImage: 顶部图片，默认值：dp_BundleImageNamed(@"dp_no_data.png");
 *  @param aTitle: 提示语，默认值：@"获取数据为空";
 *  @param aBtnTitles: 按钮文字数组，默认值：@[@"重新获取"];
 *  @param aShowType: 1 只有提示语, 2 只有图片, 3 提示语+图片;
 *  @param aLayoutType: 1 内容整体靠上位置显示, 2 内容整体居中显示, 3 内容整体靠上（距离50）位置显;
 *  @param aBtnBlock: 为nil不显示按钮;
 *
 */
+ (id)showDefaulWithSuperView:(UIView *)aSuperView topImage:(UIImage *)aTopImage title:(NSString *)aTitle btnTitles:(NSArray <NSString *>*)aBtnTitles showType:(int)aShowType layoutType:(int)aLayoutType btnBlock:(DPDefaultViewButtonBlock)aBtnBlock;

/**
 *  隐藏默认视图
 *
 *  @param aSuperView: 父视图;
 *
 */
+ (void)hiddenDefaulTSuperView:(UIView *)aSuperView;

/**
 *  隐藏默认视图
 *
 */
- (void)hiddenDefaulTSuperView;
@end
