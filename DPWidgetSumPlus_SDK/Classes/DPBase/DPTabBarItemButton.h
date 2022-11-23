//
//  DPTabBarItemButton.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPTabBarItemButton;
@class DPTabBarItemButtonData;

typedef void (^TapBolck)(DPTabBarItemButton *aObject);

@interface DPTabBarItemButton : UIView
@property (nonatomic, copy) TapBolck tapBlock;

@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) DPTabBarItemButtonData *buttonDate;

- (instancetype)initWithFrame:(CGRect)frame tapBolck:(TapBolck)block;
@end

@interface DPTabBarItemButtonData : NSObject
///参数修改回调
@property (nonatomic, copy) void (^updateBlock)(DPTabBarItemButtonData *aObject);

///按钮未点击状态 默认图片（二倍图，与服务器下发图片保持一致，去除后缀@2x，手动处理二倍图）
@property (nonatomic, strong) NSString *imageNormal;
///按钮点击状态 默认图片（二倍图，与服务器下发图片保持一致，去除后缀@2x，手动处理二倍图）
@property (nonatomic, strong) NSString *imageSelect;
///按钮未点击状态图片 url（二倍图，手动处理二倍图）
@property (nonatomic, strong) NSString *imageNormalUrl;
///按钮点击状态图片 url（二倍图，手动处理二倍图）
@property (nonatomic, strong) NSString *imageSelectUrl;
///按钮未点击状态文字颜色
@property (nonatomic, strong) UIColor *titleNormalColor;
///按钮点击状态文字颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;
///按钮未点击状态文字字号
@property (nonatomic, strong) UIFont *titleNormalFont;
///按钮点击状态文字字号
@property (nonatomic, strong) UIFont *titleSelectedFont;
///按钮未点击状态文字
@property (nonatomic, strong) NSString *titleNormalText;
///按钮点击状态文字
@property (nonatomic, strong) NSString *titleSelectedText;
///图文间隙
@property (nonatomic, assign) CGFloat imageTextGap;
///图文布局，文字距离底部间距
@property (nonatomic, assign) CGFloat bottomGap;
@end
