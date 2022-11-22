//
//  DPShareContent.m
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPShareContent.h"
#import "DPWidgetSum.h"
#import "DPShareView.h"

@interface DPShareContent () {
    
}
@end

@implementation DPShareContent
- (void)dealloc{
    
}
- (void)shareDataObject:(DPShareDataObject*)dataObject contentType:(ShareViewContentType)contentType platformType:(DPSharePlatformType)platformType controller:(UIViewController*)vc callBack:(ShareContentBlock)block{
    
    UMSocialPlatformType aPlatformType = UMSocialPlatformType_UnKnown;
    if (platformType == DPShareContentTypeWechatTimeLine) {
        aPlatformType = UMSocialPlatformType_WechatTimeLine;
    }else if (platformType == DPShareContentTypeWechatSession) {
        aPlatformType = UMSocialPlatformType_WechatSession;
    }else if (platformType == DPShareContentTypeQQZone) {
        aPlatformType = UMSocialPlatformType_Qzone;
    }else if (platformType == DPShareContentTypeQQ) {
        aPlatformType = UMSocialPlatformType_QQ;
    }else if (platformType == DPShareContentTypeSina) {
        aPlatformType = UMSocialPlatformType_Sina;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (contentType == DPShareContentTypeDefault) {
        //创建网页内容对象
        if (platformType == DPShareContentTypeSina) {
            //分享图文（新浪支持，微信/QQ仅支持图或文本分享）
            messageObject.text = dataObject.sinaText;
            if (!messageObject.text) {
                messageObject.text=dataObject.text;
            }
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            shareObject.thumbImage = dataObject.image;
            [shareObject setShareImage:dataObject.image];
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
        }else{
            //分享网页
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dataObject.title descr:dataObject.text thumImage:dataObject.image];
            //设置网页地址
            shareObject.webpageUrl =dataObject.url;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
        }
        
    }else{
        //图片
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = dataObject.image;
        [shareObject setShareImage:dataObject.image];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        messageObject.text = dataObject.sinaText;
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:aPlatformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (block) {
                //Error：微信官方sdk强制，取消分享，error仍为空。为鼓励用户自发分享喜爱的内容，减少“强制分享至不同群”等滥用分享能力
                block(data, error);
            }else{
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                    [[self class] shareErrorAlert:error.code];
                }else{
                    [DPTool showToastMsg:@"分享成功"];
                }
                
            }
        });
    }];
}

//分享失败 error.code 弹框
+ (void)shareErrorAlert:(UMSocialPlatformErrorType)aType {
    NSLog(@"Error:%ld",(long)aType);
    switch (aType) {
        case UMSocialPlatformErrorType_Unknow:{// 未知错误
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_NotSupport:{// 不支持（url scheme 没配置，或者没有配置-ObjC， 或则SDK版本不支持或则客户端版本不支持）
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_AuthorizeFailed:{// 授权失败
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_ShareFailed:{// 分享失败
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_RequestForUserProfileFailed:{// 请求用户信息失败
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_ShareDataNil:{// 分享内容为空];
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_ShareDataTypeIllegal:{// 分享内容不支持
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_CheckUrlSchemaFail:{// schemaurl fail
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_NotInstall:{// 应用未安装
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_Cancel:{// 取消操作
            [DPTool showToastMsg:@"已取消"];
        }
            break;
        case UMSocialPlatformErrorType_NotNetWork:{// 网络异常
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_SourceError:{// 第三方错误
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        case UMSocialPlatformErrorType_ProtocolNotOverride:{// 对应的    UMSocialPlatformProvider的方法没有实现
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
        default:{
            [DPTool showToastMsg:@"分享失败"];
        }
            break;
    }
}
@end

@implementation DPShareDataObject
- (id)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.text = @"";
        self.url = @"";
        self.image = @"";
        self.moreSelectType = @"";
        self.sinaText = @"";
    }
    return self;
}
@end
