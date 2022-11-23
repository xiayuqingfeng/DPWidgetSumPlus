//
//  ViewController.m
//  test
//
//  Created by xiayupeng on 2018/12/17.
//  Copyright © 2018 yupeng xia. All rights reserved.
//

#import "ViewControllerThree.h"
#import "UIImageView+WebCache.h"
#import "DPWidgetSumPlus.h"
#import "DPRefreshTableViewObject.h"
#import "DPCustomBanner.h"
#import "DPWebViewController.h"

@interface ViewControllerThree ()<DPCustomBannerDelegate> {
    UILabel *dateLab;
}
@property (nonatomic, strong) DPCustomBanner *bannerView;

@property (nonatomic, strong) NSArray *bannerDataArray;
@end

@implementation ViewControllerThree
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBarView = YES;
    
    self.contentView.isAutomaticHeight = NO;
    dp_arc_block(self);
    [self.contentView dpRefreshHeaderAdd:^(DPRefreshTableHeaderView *aObject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self.bannerView loadDataArray:weak_self.bannerDataArray];
            [weak_self.contentView dpRefreshHeaderFinish];
        });
    }];
    [self.contentView dpRefreshFooterAdd:nil];
    
    self.bannerDataArray = @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F017b2a5938c8bca8012193a37db72c.jpg%402o.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1629019873&t=c492b4fc42f4245905b7746d7e26a87d", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F018f94592e27bba801216a3e7e4501.jpg%401280w_1l_2o_100sh.png&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1629019873&t=e48b6a23d31265fb5acb303ab947d62e", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01e1775aeb21a9a801219b7f50cf0d.jpg%401280w_1l_2o_100sh.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1629019873&t=e19b41a0ab9f44ee5e491e406690ca2f", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f34459b7972ca801211d25f906c9.png%401280w_1l_2o_100sh.png&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1629019873&t=11cac0d75734b5aa366c9cae4a11fd81"];

    self.bannerView = [[DPCustomBanner alloc] init];
    _bannerView.frame = CGRectMake(0, 0, self.contentView.dp_width, DP_FrameHeight(160));
    _bannerView.delegate = self;
    _bannerView.bgImage = [UIImage imageNamed:@"default_logo1.jpg"];
    _bannerView.timeInterval = 3;
    [self.contentView addSubview:_bannerView];
    [weak_self.bannerView loadDataArray:_bannerDataArray];
}

#pragma mark <-----DPCustomBannerDelegate----->
- (UIView *)dpCustomBannerLoadViewWithObject:(DPCustomBanner *)aObject bounds:(CGRect)aBounds index:(NSInteger)aIndex data:(id)aData cyclicView:(UIView *)aCyclicView {
    UIImageView *imageView = nil;
    if (aCyclicView == nil || ![aCyclicView isKindOfClass:[UIImageView class]]) {
        imageView = [[UIImageView alloc] initWithFrame:aBounds];
    }else {
        imageView = (UIImageView *)aCyclicView;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:aData] placeholderImage:[UIImage imageNamed:@"default_logo1.jpg"]];
    return imageView;
}
- (void)dpCustomBannerTapWithObject:(DPCustomBanner *)aObject index:(NSInteger)aIndex data:(id)aData cyclicView:(UIView *)aCyclicView {
    //http://124.251.110.214:83/pages/embed/login
    //http://124.251.110.214:83/pages/embed/blockchain-detail
    DPWebViewController *vc = [DPWebViewController webViewUrl:@"http://124.251.110.214:83/pages/embed/login" withTitle:nil isDocumentTitle:YES];
    vc.fontController = self;
    [UIViewController dp_pushVc:vc superNav:self.navigationController superVc:self deleteNum:0 animated:YES];
}
@end
