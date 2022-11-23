//
//  DPBaseTextView.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DPBaseTextViewPerform) {
    ///空
    DPBaseTextViewPerformNil       = 1 << 0,
    ///剪切
    DPBaseTextViewPerformCut       = 1 << 1,
    ///拷贝
    DPBaseTextViewPerformCopy      = 1 << 2,
    ///选择
    DPBaseTextViewPerformSelect    = 1 << 3,
    //全选
    DPBaseTextViewPerformSelectAll = 1 << 4,
    ///粘贴
    DPBaseTextViewPerformPaste     = 1 << 5,
    ///删除
    DPBaseTextViewPerformDelete    = 1 << 6,
    ///所有操作
    DPBaseTextViewPerformmAllTypes     = 1 << 7
};


@interface DPBaseTextView : UITextView
///文字加载完成(联想结束) 或 text赋值完成(set赋值) block回调事件
@property (nonatomic, copy) void(^baseTextDidChangeBlock)(DPBaseTextView *aObject);

///输入框禁用操作类型，默认：DPBaseTextViewPerformNil
@property (nonatomic, assign) DPBaseTextViewPerform notTextViewPerform;
@end
