//
//  UIImage+DPCategory.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (DPCategory)
///uiview转换uimage
+ (UIImage *)dp_imageFromView:(UIView *)view;

///截图,如果是(ScrollView、TableView)可视区域区域截取
+ (UIImage *)dp_captureScreenView:(UIView *)view;

///截图,(ScrollView、TableView)全区域截取,content范围
+ (void)dp_captureScreenScrollView:(UIScrollView *)scrollView captureBlock:(void(^)(UIImage *aImage))aCaptureBlock;

/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
///从图片中按指定的位置大小截取图片的一部分,裁剪
+ (UIImage *)dp_imageCutFromImage:(UIImage *)image cutRect:(CGRect)aCutRect;

/**
 *  UIImage 垂直拼接，图片等比例、等宽拉伸
 *
 *  @param aImageArray 图片数组
 *  @param aWidth 指定拼接图片宽度，默认 0，使用最小图片宽度
 *
 *  @return UIImage 垂直拼接
 */
///UIImage 垂直拼接，图片等比例、等宽拉伸
+ (UIImage *)dp_imageJointVerticalForImageArray:(NSArray <UIImage *>*)aImageArray width:(CGFloat)aWidth gap:(CGFloat)aGap;

/**
 *  UIImage 水平拼接，图片等比例、等高拉伸
 *
 *  @param aImageArray 图片数组
 *  @param aWidth 指定拼接图片高度，默认 0，使用最小图片高度
 *  @param aGap 图片之间的间隙，默认 0
 *
 *  @return UIImage 水平拼接
 */
///UIImage 水平拼接，图片等比例、等高拉伸
+ (UIImage *)dp_imageJointLevelForImageArray:(NSArray <UIImage *>*)aImageArray height:(CGFloat)aHeight gap:(CGFloat)aGap;

/**
 *  UIImage 添加水印，垂直等宽，从上到下排列
 *
 *  @param aImage 原图片
 *  @param aLogoImage 水印图片
 *
 *  @return UIImage 组合图片
 */
///UIImage 添加水印，垂直等宽，从上到下排列
+ (UIImage *)dp_imageJointWatermarkForImage:(UIImage *)aImage logoImage:(UIImage *)aLogoImage;

/**
 *  UIImage 裁剪上下左右透明区域
 *
 *  @param aImage 原图片
 *  @param aEdge 上下左右
 *
 *  @return UIImage 裁剪图片
 */
///
+ (UIImage *)dp_imageCutTransparentAreasForImage:(UIImage *)aImage edge:(UIRectEdge)aEdge;

/**
 *  UIImage 压缩质量
 *
 *  @param aImage 原图片
 *  @param maxLength 最大体积
 *
 *  @return UIImage 压缩图片 JPEG
 */
///UIImage 压缩质量
+ (UIImage *)dp_imageCompressQuality:(UIImage *)image toByte:(NSInteger)maxLength;

/**
 *  UIImage 压缩质量
 *
 *  @param aImage 原图片
 *  @param maxLength 最大体积
 *
 *  @return NSDate  压缩图片 JPEG
 */
///UIImage 压缩质量
+ (NSData *)dp_imageDataCompressQuality:(UIImage *)image toByte:(NSInteger)maxLength;

///获取纯色值图片，大小为：CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)
+ (UIImage *)dp_imageWithColor:(UIColor *)color;

///获取纯色值图片，指定大小
+ (UIImage *)dp_imageWithColor:(UIColor *)color rect:(CGRect)rect;

///生成任意圆角边框图片
+ (UIImage*)dp_imageWithStoreColor:(UIColor*)storeColor fillColor:(UIColor*)fillColor lineWidth:(CGFloat)lineWidth size:(CGSize)size radius:(CGFloat)radius edgInset:(UIEdgeInsets)edgInset alpha:(CGFloat)alpha;

///获取bundle图片，默认
+ (UIImage *)dp_imageName:(NSString *)aImageName bundleName:(NSString *)aBundleName;

///更改图片尺寸
+ (UIImage *)dp_resizeImage:(UIImage*)image newSize:(CGSize)newSize;

///保存图片到自定义相册 aPhotoAlbumName 自定义相册名称，为空时使用App名称
+ (void)dp_saveImage:(UIImage *)aImage photoAlbumName:(NSString *)aPhotoAlbumName callBackBlock:(void(^)(NSError *error))callBackBlock;

///二维码生成；aInfoP 二维码信息；aSize：图片大小，默认 CGSizeZero (原尺寸)；aLogoImage 二维码logo；aLogoType二维码类型：0 正方形，1 圆角，2 圆形；aLogoSize logo尺寸：默认 CGSizeZero (二维码1:5)
+ (UIImage *)dp_createQRCodeWithInfo:(NSString *)aInfo imageSize:(CGSize)aImageSize logoImage:(UIImage *)aLogoImage logoType:(NSInteger)aLogoType logoSize:(CGSize)aLogoSize;

///图片高清处理 CGContext
+ (UIImage *)dp_createNonInterpolatedUIImageFromCIImage:(CIImage *)image size:(CGFloat)size;

///填充缩略图
+ (UIImage *)dp_image:(UIImage *)image fillSize:(CGSize)viewsize;

///缩略图，计算适合的大小。并保留其原始图片大小
+ (CGSize)dp_fitSize:(CGSize)thisSize inSize:(CGSize)aSize;

///圆角裁剪 CGContext；c 圆角半径；aIsScale 圆角半径是否自动适应分辨率，默认 NO；
+ (UIImage *)dp_CGContextClip:(UIImage *)img cornerRadius:(CGFloat)c isScale:(BOOL)aIsScale;

///圆角裁剪 UIBezierPath；aCornerRadius 圆角半径；aIsScale 圆角半径是否自动适应分辨率，默认 NO；
+ (UIImage *)dp_BezierPathClip:(UIImage *)aImage cornerRadius:(CGFloat)aCornerRadius isScale:(BOOL)aIsScale borderWidth:(CGFloat)aBorderWidth borderColor:(UIColor *)aBorderColor;
@end
