//
//  DPTabBarItemButton.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright © 2021年 xiayupeng. All rights reserved.
//

#import "DPTabBarItemButton.h"
#import "DPWidgetSumPlus.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DPTabBarItemButton (){
    
}
@end

@implementation DPTabBarItemButton

- (void)dealloc {
    if (self.tapBlock) {
        self.tapBlock = nil;
    }
    @try {
        [self removeObserver:self forKeyPath:@"frame"];
        [_tapButton removeObserver:self forKeyPath:@"selected"];
    }
    @catch (NSException *exception) {
        NSLog(@"多次释放KVO");
    }
}
- (instancetype)initWithFrame:(CGRect)frame tapBolck:(TapBolck)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.tapBlock = block;
    
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        self.tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapButton.frame = self.bounds;
        _tapButton.selected = NO;
        [_tapButton addTarget:self action:@selector(tabBarCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_tapButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:_tapButton];
        
        [self updataDownloadImage];
    }
    return self;
}
- (void)tabBarCenterBtn:(UIButton *)btn{
    if (self.tapBlock) {
        self.tapBlock(self);
    }
}

#pragma mark <--------------系统函数-------------->
//按钮超出父视图手势响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint tapButtonPoint = [_tapButton convertPoint:point fromView:self];
    if ([_tapButton pointInside:tapButtonPoint withEvent:event]) {
        return _tapButton;
    }

    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

#pragma mark <-------------Observer------------->
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        [self updateDataLayout];
    }else if ([keyPath isEqualToString:@"selected"]) {
        [self updateDataLayout];
        
        if (_tapButton.selected) {
            _imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            dp_arc_block(self);
            [UIView animateWithDuration:0.2 animations:^{
                weak_self.imageView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:nil];
        }
    }
}

#pragma mark <-------------Setter_methods------------->
- (void)setButtonDate:(DPTabBarItemButtonData *)buttonDate {
    _buttonDate = buttonDate;
    dp_arc_block(self);
    _buttonDate.updateBlock = ^(id obj) {
        [weak_self updateDataLayout];
    };
    [self updataDownloadImage];
}

#pragma mark <-------------layuout------------->
- (void)updataDownloadImage {
    dp_arc_block(self);
    if (_buttonDate.imageNormal.length) {
        _normalImage = [UIImage imageNamed:_buttonDate.imageNormal];
    }
    if (_buttonDate.imageNormalUrl.length) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL dp_urlEncodedString:_buttonDate.imageNormalUrl] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                weak_self.normalImage = image;
                [weak_self updateDataLayout];
            }
        }];
    }
    
    if (_buttonDate.imageSelect.length) {
        _selectedImage = [UIImage imageNamed:_buttonDate.imageSelect];
    }else if (_buttonDate.imageNormal.length) {
        _selectedImage = [UIImage imageNamed:_buttonDate.imageNormal];
    }
    if (_buttonDate.imageSelectUrl.length) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL dp_urlEncodedString:_buttonDate.imageSelectUrl] options:SDWebImageRefreshCached progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                weak_self.selectedImage = image;
                [weak_self updateDataLayout];
            }
        }];
    }
    
    [self updateDataLayout];
}
- (void)updateDataLayout {
    _imageView.image = _tapButton.selected ? _selectedImage : _normalImage;
    CGSize aImageSize = CGSizeMake(_imageView.image.size.width/2.0, _imageView.image.size.height/2.0);
    _imageView.dp_size = aImageSize;
    _imageView.dp_centerX = self.dp_width/2.0;
    
    NSString *aNormalText = _buttonDate.titleNormalText;
    NSString *aSelectedText = _buttonDate.titleSelectedText;
    if (aSelectedText.length < 1) {
        aSelectedText = aNormalText;
    }
    _titleLabel.hidden = (aNormalText.length > 0 || aSelectedText.length > 0) ? NO : YES;
    _titleLabel.textColor = _tapButton.selected ? _buttonDate.titleSelectedColor : _buttonDate.titleNormalColor;
    _titleLabel.font = _tapButton.selected ? _buttonDate.titleSelectedFont : _buttonDate.titleNormalFont;
    _titleLabel.frame = CGRectMake(0, 0, self.dp_width, 0);
    _titleLabel.text = _tapButton.selected ? aSelectedText : aNormalText;
    _titleLabel.numberOfLines = [_titleLabel.text containsString:@"\n"] ? 0 : 1;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(0, 0, self.dp_width, _titleLabel.dp_height);

    if (_titleLabel.hidden == NO) {
        CGFloat sumHeight = aImageSize.height+_buttonDate.imageTextGap+_titleLabel.dp_height+_buttonDate.bottomGap;
        _imageView.dp_y = self.dp_height-sumHeight;
        _titleLabel.dp_y = _imageView.dp_yMax+_buttonDate.imageTextGap;
        
        if (sumHeight > self.dp_height) {
            _tapButton.frame = CGRectMake(0, self.dp_height-sumHeight, self.dp_width, sumHeight);
        }else {
            _tapButton.frame = self.bounds;
        }
    }else {
        if (_imageView.dp_height > self.dp_height) {
            _imageView.dp_y = self.dp_height-aImageSize.height;
        }else {
            _imageView.dp_y = (self.dp_height-aImageSize.height)/2.0;
        }
        
        if (_imageView.dp_height > self.dp_height) {
            _tapButton.frame = CGRectMake(0, self.dp_height-_imageView.dp_height, self.dp_width, _imageView.dp_height);
        }else {
            _tapButton.frame = self.bounds;
        }
    }
}
@end

@implementation DPTabBarItemButtonData
- (void)dealloc {
    if (self.updateBlock) {
        self.updateBlock = nil;
    }
}
- (id)init{
    self = [super init];
    if (self) {
        _titleNormalFont = [UIFont systemFontOfSize:10];
        _titleSelectedFont = [UIFont systemFontOfSize:10];
        _titleNormalColor = [UIColor dp_hexToColor:@"9e9e9e"];
        _titleSelectedColor = [UIColor dp_hexToColor:@"ffe400"];
        _imageTextGap = 2;
        _bottomGap = 6;
    }
    return self;
}

#pragma mark <-------------Setter_methods------------->
- (void)setImageNormal:(NSString *)imageNormal {
    _imageNormal = imageNormal;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setImageSelect:(NSString *)imageSelect {
    _imageSelect = imageSelect;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setImageNormalUrl:(NSString *)imageNormalUrl {
    _imageNormalUrl = imageNormalUrl;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setImageSelectUrl:(NSString *)imageSelectUrl {
    _imageSelectUrl = imageSelectUrl;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setTitleNormalFont:(UIFont *)titleNormalFont {
    _titleNormalFont = titleNormalFont;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setTitleSelectedFont:(UIFont *)titleSelectedFont {
    _titleSelectedFont = titleSelectedFont;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setTitleNormalText:(NSString *)titleNormalText {
    _titleNormalText = titleNormalText;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
- (void)setTitleSelectedText:(NSString *)titleSelectedText {
    _titleSelectedText = titleSelectedText;
    if (self.updateBlock) {
        self.updateBlock(self);
    }
}
@end

