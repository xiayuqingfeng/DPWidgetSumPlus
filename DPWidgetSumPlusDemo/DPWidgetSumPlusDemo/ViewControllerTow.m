//
//  ViewController.m
//  test
//
//  Created by xiayupeng on 2018/12/17.
//  Copyright © 2018 yupeng xia. All rights reserved.
//

#import "ViewControllerTow.h"
#import "DPWidgetSumPlus.h"

@interface ViewControllerTow () {
    
}
@end

@implementation ViewControllerTow
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBarView = YES;
    
    [self reloadWebViewUrl:@"http://124.251.110.214:83/pages/embed/login"];

}
@end
