//
//  ViewController.m
//  test
//
//  Created by xiayupeng on 2018/12/17.
//  Copyright © 2018 yupeng xia. All rights reserved.
//

#import "ViewControllerSix.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DPWidgetSum.h"
#import "DPTextField.h"
#import "ViewController.h"

@interface ViewControllerSix (){
    DPTextField *uTextField;
    DPTextField *cTextField;
    DPTextField *pTextField;
    UIButton *dealDoBtn;
    UIButton *dealBtn;
    UIButton *goBtn;
    UIButton *newBtn;
    UIButton *regBtn;
}
@end

@implementation ViewControllerSix
- (void)viewDidLoad{
    [super viewDidLoad];
    self.isHiddenNavBarView = YES;

    //账户
    uTextField = [[DPTextField alloc] initWithFrame:CGRectMake(0, DP_FrameHeight(10), self.contentView.dp_width, DP_FrameHeight(60)) delegate:self superView:self.contentView];
//    uTextField.textFieldType = DPTextFieldTypeCell;
    uTextField.leftImage = [UIImage imageNamed:@"dp_yonghu.png"];
    uTextField.textFont = DP_Font(18);
    uTextField.placeholder = @"请输入您的手机号";
    uTextField.textLimitType = 0;
    uTextField.textLengthMax = @"11";
    uTextField.textMaxMessage = @"手机号长度最多为11个数字";
    uTextField.textRegular = @"0-9";
    uTextField.aTextField.returnKeyType = UIReturnKeyNext;
    [self.contentView addSubview:uTextField];
    
    //验证码
    cTextField = [[DPTextField alloc] initWithFrame:CGRectMake(0, uTextField.dp_yMax+DP_FrameHeight(8), self.contentView.dp_width, DP_FrameHeight(60)) delegate:self superView:self.contentView];
    cTextField.textFieldType = DPTextFieldTypeCode;
    cTextField.leftImage = [UIImage imageNamed:@"dp_yzm.png"];
    cTextField.textFont = DP_Font(18);
    cTextField.placeholder = @"请输入您的短信验证码";
    cTextField.textLimitType = 1;
    cTextField.textLengthMax = @"6";
    cTextField.textMaxMessage = @"验证码长度最多为6个字符";
    cTextField.textRegular = @"0-9";
    cTextField.aTextField.keyboardType = UIKeyboardTypeNumberPad;
    cTextField.fontTextField = uTextField;
    dp_arc_block(uTextField);
    cTextField.textFieldButtonBlock = ^(DPTextField * _Nonnull aObject) {
        if (weak_uTextField.aTextField.text.length < 1) {
            [DPTool showToastMsg:@"请输入手机号码"];
        }else {
            //开启验证码倒计时
            [aObject beginCodeTimer];
            [aObject.aTextField becomeFirstResponder];
        }
    };
    [self.contentView addSubview:cTextField];
    
    //密码
    pTextField = [[DPTextField alloc] initWithFrame:CGRectMake(0, cTextField.dp_yMax+DP_FrameHeight(8), self.contentView.dp_width, DP_FrameHeight(60)) delegate:self superView:self.contentView];
    pTextField.textFieldType = DPTextFieldTypePassword;
    pTextField.leftImage = [UIImage imageNamed:@"dp_mima.png"];
    pTextField.rightNImage = [UIImage imageNamed:@"dp_bukejian.png"];
    pTextField.rightSImage = [UIImage imageNamed:@"dp_kejian.png"];
    pTextField.textFont = DP_Font(18);
    pTextField.placeholder = @"请输入密码";
    pTextField.textLimitType = 1;
    pTextField.textLengthMax = @"16";
    pTextField.textMaxMessage = @"密码长度最多为?个字符";
    pTextField.textNoRegular = @"\u4E00-\u9FA5";
    pTextField.fontTextField = cTextField;
    [self.contentView addSubview:pTextField];
    
    //遵守协议
    dealDoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dealDoBtn setImage:[UIImage imageNamed:@"icon_not_selected.png"] forState:UIControlStateNormal];
    [dealDoBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateSelected];
    dealDoBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    dealDoBtn.titleLabel.font = DP_Font(14);
    [dealDoBtn setTitleColor:DP_RGBA(115, 127, 174, 1) forState:UIControlStateNormal];
    [dealDoBtn setTitle:@" 同意" forState:UIControlStateNormal];
    [dealDoBtn sizeToFit];
    dealDoBtn.frame = CGRectMake(DP_FrameWidth(16), pTextField.dp_yMax+DP_FrameWidth(10), dealDoBtn.dp_width, dealDoBtn.dp_height);
    dealDoBtn.selected = YES;
    [[dealDoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.selected = !x.selected;
    }];
    [self.contentView addSubview:dealDoBtn];
    
    //注册协议
    dealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dealBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    dealBtn.titleLabel.font = DP_Font(14);
    [dealBtn setTitleColor:DP_RGBA(77, 129, 247, 1) forState:UIControlStateNormal];
    [dealBtn setTitle:@"《注册协议》" forState:UIControlStateNormal];
    [dealBtn sizeToFit];
    dealBtn.dp_x = dealDoBtn.dp_xMax+DP_FrameWidth(2);
    dealBtn.dp_centerY = dealDoBtn.dp_centerY;
    [[dealBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    [self.contentView addSubview:dealBtn];
    
    UIView *btLineView = [[UIView alloc] init];
    btLineView.frame = CGRectMake(0, dealBtn.dp_height/2+dealBtn.titleLabel.font.lineHeight/2, dealBtn.dp_width, 1);
    btLineView.backgroundColor = [dealBtn titleColorForState:UIControlStateNormal];
    [dealBtn addSubview:btLineView];
    
    //去登录
    goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    goBtn.titleLabel.font = DP_Font(14);
    [goBtn setTitleColor:DP_RGBA(77, 129, 247, 1) forState:UIControlStateNormal];
    [goBtn setTitle:@"已有账号 去登录" forState:UIControlStateNormal];
    [goBtn sizeToFit];
    goBtn.dp_x = self.contentView.dp_width-DP_FrameWidth(16)-goBtn.dp_width;
    goBtn.dp_centerY = dealDoBtn.dp_centerY;
    [[goBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

    }];
    [self.contentView addSubview:goBtn];
    
    //新用户注册
    NSString *newReg = @"新用户注册立领126元|http://yqyl20.caiminbang.com/getGift";
    NSArray <NSString *>*newRegArray = [newReg componentsSeparatedByString:@"|"];
    if (newRegArray.count == 2) {
        newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        newBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        newBtn.titleLabel.font = DP_Font(14);
        [newBtn setTitleColor:DP_RGBA(77, 129, 247, 1) forState:UIControlStateNormal];
        [newBtn setTitle:newRegArray.firstObject forState:UIControlStateNormal];
        [newBtn sizeToFit];
        newBtn.dp_centerX = self.contentView.dp_width/2;
        newBtn.dp_y = dealDoBtn.dp_yMax+DP_FrameWidth(32);
        [[newBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
        }];
        [self.contentView addSubview:newBtn];
        
        UIView *btLineView = [[UIView alloc] init];
        btLineView.frame = CGRectMake(0, newBtn.dp_height/2+newBtn.titleLabel.font.lineHeight/2, newBtn.dp_width, 1);
        btLineView.backgroundColor = [newBtn titleColorForState:UIControlStateNormal];
        [newBtn addSubview:btLineView];
    }
    
    //注册
    regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.dp_size = CGSizeMake(DP_FrameWidth(210), DP_FrameHeight(40));
    regBtn.dp_centerX = self.contentView.dp_width/2;
    regBtn.dp_y = newBtn.dp_yMax+DP_FrameHeight(2);
    regBtn.layer.masksToBounds = YES;
    regBtn.layer.cornerRadius = regBtn.dp_height/2;
    regBtn.backgroundColor = DP_RGBA(51, 105, 227, 1);
    regBtn.titleLabel.font = DP_FontBold(16);
    [regBtn setTitleColor:DP_RGBA(255, 254, 254, 1) forState:UIControlStateNormal];
    [regBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    dp_arc_block(self);
    [[regBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ViewController *vc = [[ViewController alloc] init];
        [weak_self dp_pushVc:vc animated:YES];
    }];
    [self.contentView addSubview:regBtn];
}
@end
