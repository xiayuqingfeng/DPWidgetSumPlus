//
//  DPShareContent.h
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
@class DPShareDataObject;

typedef NS_ENUM(NSUInteger, ShareViewContentType) {
    ///图文URL分享
    DPShareContentTypeDefault = 1,
    ///纯图片分享（QQ空间不支持）
    DPShareContentTypeImage = 2
};

typedef NS_ENUM(NSUInteger, DPSharePlatformType) {
    ///关闭分享菜单
    DPShareContentTypeCloseView = 0,
    ///保存图片
    DPShareContentTypeSaveImage = 5,
    ///QQ好友
    DPShareContentTypeQQ = 4,
    ///QQ空间
    DPShareContentTypeQQZone = 3,
    ///新浪微博
    DPShareContentTypeSina = 6,
    ///微信好友
    DPShareContentTypeWechatSession = 2,
    ///朋友圈
    DPShareContentTypeWechatTimeLine = 1
};

typedef void(^ShareContentBlock)(id data, NSError *error);

@interface DPShareContent : NSObject
- (void)shareDataObject:(DPShareDataObject *)dataObject contentType:(ShareViewContentType)contentType platformType:(DPSharePlatformType)platformType controller:(UIViewController *)vc callBack:(ShareContentBlock)block;

///分享失败 error.code 弹框
+ (void)shareErrorAlert:(UMSocialPlatformErrorType)aType;
@end

@interface DPShareDataObject : NSObject
///分享标题，默认值：空字符串
@property (nonatomic, strong) NSString *title;
///分享内容，默认值：空字符串
@property (nonatomic, strong) NSString *text;
///分享地址 url，默认值：空字符串
@property (nonatomic, strong) NSString *url;
///缩略图 UIImage或者NSData类型或者NSString类型（图片url），默认值：空
@property (nonatomic, strong) id image;
///当前使用平台按钮控制参数（多参数123456，1 微信朋友圈，2 微信，3 QQ空间，4 QQ，5 保存图片到相册，6 新浪微博），默认值：空字符串
@property (nonatomic, strong) NSString *moreSelectType;
///缩略图 UIImage或者NSData类型或者NSString类型（图片url），默认值：空字符串
@property (nonatomic, strong) NSString *sinaText;
@end
