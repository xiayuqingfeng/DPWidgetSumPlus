//
//  DPShareView.m
//  DPWidgetSumDemo
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import "DPShareView.h"
#import "DPWidgetSum.h"
#import <UMShare/UMShare.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define bgViewTag 968968
#define animateTime 0.25

@interface DPShareView () {
    
}
@end

@implementation DPShareView
- (void)dealloc {
    if (self.platformBack) {
        self.platformBack = nil;
    }
    if (self.callBack) {
        self.callBack = nil;
    }
}

+ (void)directShareForPlatformType:(DPSharePlatformType)aPlatformType shareDataObject:(DPShareDataObject *)aDataObject contentType:(ShareViewContentType)aContentType currentVc:(UIViewController *)aCurrentVc callBack:(ShareViewContentBlock)aCallBack {
    
    if (aPlatformType == DPShareContentTypeSaveImage) {
        //保存图片 按钮点击事件
        if ([aDataObject.image isKindOfClass:[UIImage class]]) {
            [UIImage dp_saveImage:aDataObject.image photoAlbumName:nil callBackBlock:^(NSError *error) {
                if (error) {
                    [DPTool showToastMsg:@"保存图片失败!"];
                } else {
                    [DPTool showToastMsg:@"保存图片成功!"];
                }
            }];
        }else if ([aDataObject.image isKindOfClass:[NSString class]]) {
            NSString *imageUrl = aDataObject.image;
            if ([imageUrl containsString:@"http://"] || [imageUrl containsString:@"https://"]) {
                
                [DPAlertLoadingView showAlertLoadingViewToView:[UIApplication sharedApplication].dp_keyWindow];
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL dp_urlEncodedString:imageUrl] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [DPAlertLoadingView hideAllAlertLoadingViewAtView:[UIApplication sharedApplication].dp_keyWindow];
                    
                    if (error) {
                        [DPTool showToastMsg:@"保存图片失败!"];
                    }else if (finished == YES && image !=  nil) {
                        [UIImage dp_saveImage:image photoAlbumName:nil callBackBlock:^(NSError *error) {
                            if (error) {
                                [DPTool showToastMsg:@"保存图片失败!"];
                            } else {
                                [DPTool showToastMsg:@"保存图片成功!"];
                            }
                        }];
                    }
                    
                    if (aCallBack) {
                        aCallBack(nil, aPlatformType, image, error);
                    }
                }];
            }
        }
    }else {
        //选择分享平台 按钮点击事件
        DPShareContent *shareContext = [[DPShareContent alloc]init];
        [shareContext shareDataObject:aDataObject contentType:aContentType platformType:aPlatformType controller:aCurrentVc callBack:^(id data, NSError *error) {
            if (aCallBack) {
                aCallBack(nil, aPlatformType, data, error);
            }
        }];
    }
}

+ (DPShareView *)createShareView:(UIView *)aSuperView shareDataObject:(DPShareDataObject *)aDataObject contentType:(ShareViewContentType)aContentType currentVc:(UIViewController *)aCurrentVc platformBack:(ShareViewPlatformBlock)aPlatformBack callBack:(ShareViewContentBlock)aCallBack {
    return [self createShareView:aSuperView shareDataObject:aDataObject contentType:aContentType currentVc:aCurrentVc style:0 platformBack:aPlatformBack callBack:aCallBack];
}

+ (DPShareView *)createShareView:(UIView *)aSuperView shareDataObject:(DPShareDataObject *)aDataObject contentType:(ShareViewContentType)aContentType currentVc:(UIViewController *)aCurrentVc style:(NSInteger)aStyle platformBack:(ShareViewPlatformBlock)aPlatformBack callBack:(ShareViewContentBlock)aCallBack {
    if (!aSuperView) {
        aSuperView = [UIApplication sharedApplication].dp_keyWindow;
    }
    
    for (UIView *aView in aSuperView.subviews) {
        if ([aView isKindOfClass:[DPShareView class]]) {
            [aView removeFromSuperview];
        }
    }
    
    DPShareView *shareView = [[DPShareView alloc] initWithFrame:aSuperView.bounds];
    shareView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    shareView.backgroundColor = DPSMDate.shareViewGB_viewStyle[@"bgColor"];
    shareView.hidden = NO;
    shareView.platformBack = aPlatformBack;
    shareView.callBack = aCallBack;
    shareView.shareViewStyle = aStyle;
    shareView.currentVc = aCurrentVc;
    shareView.dataObject = aDataObject;
    shareView.contentType = aContentType;
    [aSuperView addSubview:shareView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, shareView.dp_width, 0)];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    bgView.dp_centerX = shareView.dp_width/2;
    bgView.backgroundColor = DPSMDate.shareViewCenter_viewStyle[@"bgColor"];
    bgView.tag = bgViewTag;
    [shareView addSubview:bgView];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 100, 35)];
    label.font = DPSMDate.shareViewTitle_labStyle[@"font"];
    label.textColor = DPSMDate.shareViewTitle_labStyle[@"textColor"];
    label.text = DPSMDate.shareViewTitle_labStyle[@"text"];
    CGSize size = [label sizeThatFits:label.dp_size];
    label.dp_width = size.width;
    [bgView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(bgView.dp_width-35, 0, 35, 35);
    [btn setImage:dp_BundleImageNamed(@"dp_share_close.png") forState:UIControlStateNormal];
    [btn addTarget:shareView action:@selector(shareCloseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, bgView.dp_width, [DPSMDate.shareViewTop_borderLineStyle[@"borderWidth"] floatValue])];
    lineView.backgroundColor = DPSMDate.shareViewTop_borderLineStyle[@"bgColor"];
    [bgView addSubview:lineView];
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:10];
    if (shareView.dataObject.moreSelectType.length < 1) {
        shareView.dataObject.moreSelectType = @"21";
    }
    for (int i = 0; i < shareView.dataObject.moreSelectType.length; i++) {
        NSString *rangStr = [shareView.dataObject.moreSelectType substringWithRange:NSMakeRange(i, 1)];
        if ([rangStr isEqualToString:@"1"]) {
            [titleArray addObject:@"朋友圈"];
            [imageArray addObject:DPSMDate.shareView_imageValus[@"imageOne"]];
        }else if ([rangStr isEqualToString:@"2"]) {
            [titleArray addObject:@"微信"];
            [imageArray addObject:DPSMDate.shareView_imageValus[@"imageTow"]];
        }else if ([rangStr isEqualToString:@"3"]) {
            [titleArray addObject:@"QQ空间"];
            [imageArray addObject:DPSMDate.shareView_imageValus[@"imageThree"]];
        }else if ([rangStr isEqualToString:@"4"]) {
            [titleArray addObject:@"QQ"];
            [imageArray addObject:DPSMDate.shareView_imageValus[@"imageFour"]];
        }else if ([rangStr isEqualToString:@"5"]) {
            [titleArray addObject:@"保存"];
            [imageArray addObject:DPSMDate.shareView_imageValus[@"imageFive"]];
        }else if ([rangStr isEqualToString:@"6"]) {
            [titleArray addObject:@"新浪微博"];
            [imageArray addObject:DPSMDate.shareView_imageValus[@"imageSix"]];
        }
    }
    
    NSInteger vCount = titleArray.count < 3 ? titleArray.count : 3;
    CGFloat width = 52;
    CGFloat height = 75;
    CGFloat btnHGap = (bgView.dp_width-width*vCount)/(vCount+1);
    CGFloat btnVGap = 20;
    for (int i = 0; i<titleArray.count; i++) {
        NSInteger vIndex = i%vCount;
        NSInteger hIndex = i/vCount;
        DPShareBtn *btn = [DPShareBtn buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnHGap+vIndex*(width+btnHGap), lineView.dp_yMax+btnVGap+ hIndex*(btnVGap+height), width, height);
        btn.tag = 200+i;
        UIImage *aImage = [imageArray dp_objectAtIndex:i];
        [btn setImage:aImage forState:UIControlStateNormal];
        btn.adjustsImageWhenDisabled = NO;
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        btn.titleLabel.font = DP_Font(12);
        [btn setTitleColor:DP_RGBA(0, 0, 51, 1) forState:UIControlStateNormal];
        NSString *aTitle = [titleArray dp_objectAtIndex:i];
        if ([aTitle isEqualToString:@"朋友圈"]) {
            btn.aPlatformType = DPShareContentTypeWechatTimeLine;
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                //未安装微信
                btn.enabled = NO;
                btn.alpha = 0.3;
            }
        }
        if ([aTitle isEqualToString:@"微信"]) {
            btn.aPlatformType = DPShareContentTypeWechatSession;
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                //未安装微信
                btn.enabled = NO;
                btn.alpha = 0.3;
            }
        }
        if ([aTitle isEqualToString:@"新浪微博"]) {
            btn.aPlatformType = DPShareContentTypeSina;
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
                //未安装新浪微博
                btn.enabled = NO;
                btn.alpha = 0.3;
            }
        }
        if ([aTitle isEqualToString:@"QQ空间"]) {
            btn.aPlatformType = DPShareContentTypeQQZone;
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                //未安装QQ
                btn.enabled = NO;
                btn.alpha = 0.3;
            }
        }
        if ([aTitle isEqualToString:@"QQ"]) {
            btn.aPlatformType = DPShareContentTypeQQ;
            if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ] && ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                //未安装QQ
                btn.enabled = NO;
                btn.alpha = 0.3;
            }
        }
        if ([aTitle isEqualToString:@"保存"]) {
            btn.aPlatformType = DPShareContentTypeSaveImage;
        }
        [btn setTitle:aTitle forState:UIControlStateNormal];
        [btn addTarget:shareView action:@selector(umShareViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        bgView.dp_height = btn.dp_yMax+btnVGap;
    }
    
    [shareView shareViewOpen];
    
    return shareView;
}
- (void)umShareViewBtn:(DPShareBtn *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClickedAction:) object:sender];
    [self performSelector:@selector(buttonClickedAction:) withObject:sender afterDelay:0.25];
}
- (void)buttonClickedAction:(DPShareBtn *)sender {
    if (self.platformBack) {
        BOOL isAllow = self.platformBack(self, sender.aPlatformType);
        if (isAllow == NO) {
            return;
        }
    }
    
    dp_arc_block(self);
    dp_arc_block(sender);
    [[self class] directShareForPlatformType:sender.aPlatformType shareDataObject:_dataObject contentType:_contentType currentVc:_currentVc callBack:^(DPShareView *aObject, DPSharePlatformType platformType, id data, NSError *error) {
        if (weak_self.callBack) {
            weak_self.callBack(weak_self, weak_sender.aPlatformType, data, error);
        }
        
        //分享弹框使用完毕，销毁弹框
        if (weak_self.superview) {
            [weak_self removeFromSuperview];
        }
    }];
    
    [self shareViewClose];
}
- (void)shareCloseBtnAction {
    if (self.platformBack) {
        self.platformBack(self, DPShareContentTypeCloseView);
    }
    [self shareViewClose];
}

#pragma mark <--------------动画打开/关闭弹框-------------->
//动画打开弹框
- (void)shareViewOpen {
    UIView *bgView = [self viewWithTag:bgViewTag];
    dp_arc_block(self);
    if (self.hidden == YES) {
        self.alpha = 0;
        bgView.dp_y = self.dp_height;
        self.hidden = NO;
        [UIView animateWithDuration:animateTime animations:^{
            weak_self.alpha = 1;
            if (weak_self.shareViewStyle == 0) {
                bgView.dp_y = weak_self.dp_height-bgView.dp_height;
            }else if(weak_self.shareViewStyle == 1) {
                bgView.dp_centerY = weak_self.dp_height/2;
            }
        } completion:nil];
    }else {
        self.alpha = 1;
        if (weak_self.shareViewStyle == 0) {
            bgView.dp_y = weak_self.dp_height-bgView.dp_height;
        }else if(weak_self.shareViewStyle == 1) {
            bgView.dp_centerY = weak_self.dp_height/2;
        }
    }
}
//动画关闭弹框
- (void)shareViewClose {
    UIView *bgView = [self viewWithTag:bgViewTag];
    [UIView animateWithDuration:animateTime animations:^{
        bgView.dp_y = self.dp_height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if ([self superview]) {
            [self removeFromSuperview];
        }
    }];
}
@end
