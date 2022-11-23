//
//  UIImage+DPCategory.m
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import "UIImage+DPCategory.h"
#import <objc/message.h>
#import <Photos/Photos.h>
#import "DPWidgetSumPlus.h"
#import "DPPermissionsTool.h"
#import "DPMessageAlertView.h"

@implementation UIImage (DPCategory)
//uiview转换uimage
+ (UIImage *)dp_imageFromView:(UIView *)view{
    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//截图,如果是(ScrollView、TableView)可视区域区域截取
+ (UIImage *)dp_captureScreenView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.dp_size, view.opaque, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//截图,(ScrollView、TableView)全区域截取,content范围
+ (void)dp_captureScreenScrollView:(UIScrollView *)scrollView captureBlock:(void(^)(UIImage *aImage))aCaptureBlock {
    CGRect savedFrame = scrollView.frame;
    CGPoint savedContentOffset = scrollView.contentOffset;
    
    double delayInThree = 0.01;
    //tableview内容过多，contentSize高度不准确，截图不全，修改限制区域最大值，延迟截图，
    if ([scrollView isKindOfClass:[UITableView class]]) {
        delayInThree = 0.3;
        scrollView.dp_height = 10000;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInThree * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize savedContentSize = scrollView.contentSize;
        scrollView.frame = CGRectMake(0, 0, savedContentSize.width, savedContentSize.height);
        scrollView.layer.frame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        
        UIGraphicsBeginImageContextWithOptions(savedContentSize, scrollView.opaque, [UIScreen mainScreen].scale);
        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        scrollView.frame = savedFrame;
        scrollView.layer.frame = scrollView.frame;
        scrollView.contentOffset = savedContentOffset;
        
        if (image.size.width <= 0 || image.size.height <= 0) {
            image = nil;
        }
        
        if (aCaptureBlock) {
            aCaptureBlock(image);
        }
    });
}
/**
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
//从图片中按指定的位置大小截取图片的一部分,裁剪
+ (UIImage *)dp_imageCutFromImage:(UIImage *)image cutRect:(CGRect)aCutRect{
    //把(像素rect)转化为(点rect)（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect dianRect = CGRectMake(aCutRect.origin.x*scale, aCutRect.origin.y*scale, aCutRect.size.width*scale, aCutRect.size.height*scale);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    return newImage;
}

/**
 *  UIImage 垂直拼接，图片等比例、等宽拉伸
 *
 *  @param aImageArray 图片数组
 *  @param aWidth 指定拼接图片宽度，默认 0，使用最小图片宽度
 *  @param aGap 图片之间的间隙，默认 0
 *
 *  @return UIImage 垂直拼接
 */
+ (UIImage *)dp_imageJointVerticalForImageArray:(NSArray <UIImage *>*)aImageArray width:(CGFloat)aWidth gap:(CGFloat)aGap {
    //为空判断
    if (aImageArray.count < 1) {
        return nil;
    }
    
    //单张图片处理
    if (aImageArray.count == 1) {
        UIImage *oneImage = aImageArray.firstObject;
        if (((int)oneImage.size.width) == ((int)aWidth)) {
            return oneImage;
        }
    }
    
    //无效图片过滤
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:aImageArray.count];
    for (UIImage *image in mutArray) {
        if (image.size.width > 0 && image.size.height > 0) {
            [mutArray addObject:image];
        }
    }
    aImageArray = [NSArray arrayWithArray:aImageArray];
    
    //未设置合成图片宽度，筛选图片最小宽度
    if (aWidth <= 0) {
        CGFloat minWidth = 1000000;
        for (UIImage *aImage in aImageArray) {
            if (aImage && aImage.size.width < minWidth) {
                minWidth = aImage.size.width;
            }
        }
        aWidth = minWidth;
    }
    
    //根据小高度，根据宽度等比修改图片宽高，计算所有图片高度总和
    CGFloat sumHeight = 0;
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:aImageArray.count];
    for (UIImage *aImage in aImageArray) {
        if (aImage) {
            CGFloat imageHeight = aImage.size.height*aWidth/aImage.size.width;
            sumHeight = sumHeight+imageHeight;
 
            UIImage *scaledImage = nil;
            if (aImage.size.width != aWidth) {
                scaledImage = [UIImage dp_resizeImage:aImage newSize:CGSizeMake(aWidth, imageHeight)];
            }else {
                scaledImage = aImage;
            }
            if (scaledImage) {
                [newArray addObject:scaledImage];
            }
        }
    }
    aImageArray = [NSArray arrayWithArray:newArray];
    
    //根据图片间隙，计算合成图片总高度
    if (aImageArray.count > 1) {
        sumHeight = sumHeight+aGap*(aImageArray.count-1);
    }
    
    //图片拼接合成，添加间隙
    CGSize size = CGSizeMake(aWidth, sumHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGFloat minY = 0;
    for (UIImage *aImage in aImageArray) {
        if (aImage) {
            CGFloat imageHeight = aImage.size.height*aWidth/aImage.size.width;
            [aImage drawInRect:CGRectMake(0, minY, aWidth, imageHeight)];
            minY = minY+imageHeight+aGap;
        }
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

/**
 *  UIImage 水平拼接，图片等比例、等高拉伸
 *
 *  @param aImageArray 图片数组
 *  @param aWidth 指定拼接图片高度，默认 0，使用最小图片高度
 *  @param aGap 图片之间的间隙，默认 0
 *
 *  @return UIImage 水平拼接
 */
+ (UIImage *)dp_imageJointLevelForImageArray:(NSArray <UIImage *>*)aImageArray height:(CGFloat)aHeight gap:(CGFloat)aGap {
    //为空判断
    if (aImageArray.count < 1) {
        return nil;
    }
    
    //单张图片处理
    if (aImageArray.count == 1) {
        UIImage *oneImage = aImageArray.firstObject;
        if (((int)oneImage.size.height) == ((int)aHeight)) {
            return oneImage;
        }
    }
    
    //无效图片过滤
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:aImageArray.count];
    for (UIImage *image in mutArray) {
        if (image.size.width > 0 && image.size.height > 0) {
            [mutArray addObject:image];
        }
    }
    aImageArray = [NSArray arrayWithArray:aImageArray];
    
    //未设置合成图片高度，筛选图片最小高度
    if (aHeight <= 0) {
        CGFloat minHeight = 1000000;
        for (UIImage *aImage in aImageArray) {
            if (aImage && aImage.size.height < minHeight) {
                minHeight = aImage.size.height;
            }
        }
        aHeight = minHeight;
    }
    
    //根据小高度，根据高度等比修改图片宽高，计算所有图片宽度总和
    CGFloat sumWidth = 0;
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:aImageArray.count];
    for (UIImage *aImage in aImageArray) {
        if (aImage) {
            CGFloat imageWidth = aImage.size.width*aHeight/aImage.size.height;
            sumWidth = sumWidth+imageWidth;
 
            UIImage *scaledImage = nil;
            if (aImage.size.width != aHeight) {
                scaledImage = [UIImage dp_resizeImage:aImage newSize:CGSizeMake(aHeight, imageWidth)];
            }else {
                scaledImage = aImage;
            }
            if (scaledImage) {
                [newArray addObject:scaledImage];
            }
        }
    }
    aImageArray = [NSArray arrayWithArray:newArray];
    
    //根据图片间隙，计算合成图片总宽度
    if (aImageArray.count > 1) {
        sumWidth = sumWidth+aGap*(aImageArray.count-1);
    }
    
    //图片拼接合成，添加间隙
    CGSize size = CGSizeMake(sumWidth, aHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGFloat minX = 0;
    for (UIImage *aImage in aImageArray) {
        if (aImage) {
            CGFloat imageWidth = aImage.size.height*aHeight/aImage.size.width;
            [aImage drawInRect:CGRectMake(minX, 0, aHeight, imageWidth)];
            minX = minX+imageWidth+aGap;
        }
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

/**
 *  UIImage 添加水印，垂直等宽，从上到下排列
 *
 *  @param aImage 原图片
 *  @param aLogoImage 水印图片
 *
 *  @return UIImage 组合图片
 */
+ (UIImage *)dp_imageJointWatermarkForImage:(UIImage *)aImage logoImage:(UIImage *)aLogoImage {
    //判断修改图片是否有效
    if (aImage == nil || aImage.size.width <= 0 || aImage.size.height <= 0) {
        return aImage;
    }
    
    //判断水印图片是否有效
    if (aLogoImage == nil || aLogoImage.size.width <= 0 || aLogoImage.size.height <= 0) {
        return aImage;
    }

    //垂直等宽、从上到下排列添加水印
    UIGraphicsBeginImageContextWithOptions(aImage.size, NO, 0);
    [aImage drawInRect:CGRectMake(0, 0, aImage.size.width, aImage.size.height)];
    CGFloat minY = 0;
    for (int i = 0; i < 100; i++) {
        UIImage *newLogoImage = [UIImage imageWithCGImage:[aLogoImage CGImage]];
        CGFloat newHeight = newLogoImage.size.height*aImage.size.width/newLogoImage.size.width;
        [newLogoImage drawInRect:CGRectMake(0, minY, aImage.size.width, newHeight)];
        minY = minY+newHeight;
        if (minY > aImage.size.height) {
            break;
        }
    }
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

/**
 *  UIImage 裁剪上下左右透明区域
 *
 *  @param aImage 原图片
 *  @param aEdge 上下左右
 *
 *  @return UIImage 裁剪图片
 */
+ (UIImage *)dp_imageCutTransparentAreasForImage:(UIImage *)aImage edge:(UIRectEdge)aEdge {
    if (aImage == nil || aImage.size.width <= 0 || aImage.size.height <= 0) {
        return aImage;
    }

    CGImageRef cgimage = aImage.CGImage;
    //图
    size_t width = CGImageGetWidth(cgimage);
    //图片高
    size_t height = CGImageGetHeight(cgimage);
    //取图片首地址
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char));
    //rgba每个component bits数目
    size_t bitsPerComponent = 8;
    //一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    size_t bytesPerRow = width * 4;
    //创建rgb颜色空间
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    //创建位图上下文
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast |
                                                 kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    
    size_t top = 0;
    if (aEdge & UIRectEdgeTop) {
        for (size_t y = 0; y < height; y++) {
            int alpha = 0;
            for (size_t x = 0; x < width; x++) {
                alpha = data[y*width*4+x*4];
                if (alpha > 0) {
                    top = y;
                    break;
                }
            }
            if (alpha > 0) {
                break;
            }
        }
    }
    
    size_t left = 0;
    if (aEdge & UIRectEdgeLeft) {
        for (size_t x = 0; x < width; x++) {
            int alpha = 0;
            for (size_t y = 0; y < height; y++) {
                alpha = data[y*width*4+x*4];
                if (alpha > 0) {
                    left = x;
                    break;
                }
            }
            if (alpha > 0) {
                break;
            }
        }
    }
    
    size_t right = width;
    if (aEdge & UIRectEdgeRight) {
        for (size_t x = width-1; x >= 0; x--) {
            int alpha = 0;
            for (size_t y = 0; y < height; y++) {
                alpha = data[y*width*4+x*4];
                if (alpha > 0) {
                    right = x;
                    break;
                }
            }
            if (alpha > 0) {
                break;
            }
        }
    }
    
    size_t bottom = height;
    if (aEdge & UIRectEdgeBottom) {
        for (size_t y = height-1; y >= 0 ; y--) {
            int alpha = 0;
            for (size_t x = 0; x < width; x++) {
                alpha = data[y*width*4+x*4 ];
                if (alpha > 0) {
                    bottom = y;
                    break;
                }
            }
            if (alpha > 0) {
                break;
            }
        }
    }
    //关闭位图上下文
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    
    //裁剪透明区域
    CGImageRef newImageRef = CGImageCreateWithImageInRect(aImage.CGImage, CGRectMake(left, top, width-left, bottom-top));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

/**
 *  UIImage 压缩质量
 *
 *  @param aImage 原图片
 *  @param maxLength 最大体积
 *
 *  @return UIImage  压缩图片 JPEG
 */
+ (UIImage *)dp_imageCompressQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    if (image == nil || image.size.width <= 0 || image.size.height <= 0) {
        return image;
    }
    
    NSData *data = [UIImage dp_imageDataCompressQuality:image toByte:maxLength];
    if (data.length < maxLength) {
        return image;
    }

    if (data == nil) {
        return image;
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    if (resultImage == nil) {
        return image;
    }
    
    return resultImage;
}

/**
 *  UIImage 压缩质量
 *
 *  @param aImage 原图片
 *  @param maxLength 最大体积
 *
 *  @return NSData  压缩图片 JPEG
 */
+ (NSData *)dp_imageDataCompressQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    if (image == nil || image.size.width <= 0 || image.size.height <= 0) {
        return nil;
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    if (data.length < maxLength) {
        return data;
    };
    
    CGFloat compression = 1;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

//获取纯色值图片，大小为：CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)
+ (UIImage *)dp_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIImage *image = [UIImage dp_imageWithColor:color rect:rect];
    return image;
}

//获取纯色值图片，指定大小
+ (UIImage *)dp_imageWithColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//生成任意圆角边框图片
+ (UIImage*)dp_imageWithStoreColor:(UIColor*)storeColor fillColor:(UIColor*)fillColor lineWidth:(CGFloat)lineWidth size:(CGSize)size radius:(CGFloat)radius edgInset:(UIEdgeInsets)edgInset alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context,alpha);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, storeColor.CGColor);

    CGRect rect=CGRectMake(lineWidth/2+edgInset.left, lineWidth/2+edgInset.top, size.width-lineWidth-edgInset.left-edgInset.right, size.height-lineWidth-edgInset.top-edgInset.bottom);
    CGFloat ra=MIN(radius, MIN(rect.size.width/2, rect.size.height/2));
    UIBezierPath* path=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:ra];
    path.lineWidth=lineWidth;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    [path fill];
    [path stroke];
    return UIGraphicsGetImageFromCurrentImageContext();
}

//获取bundle图片，默认
+ (UIImage *)dp_imageName:(NSString *)aImageName bundleName:(NSString *)aBundleName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:aBundleName ofType:@"bundle"];
    UIImage *bundleImage = [UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:aImageName]];
    return bundleImage;
}

//更改图片尺寸
+ (UIImage *)dp_resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//保存图片到自定义相册 aPhotoAlbumName 自定义相册名称，为空时使用App名称
+ (void)dp_saveImage:(UIImage *)aImage photoAlbumName:(NSString *)aPhotoAlbumName callBackBlock:(void(^)(NSError *error))callBackBlock{
    if (aImage == nil) {
        NSLog(@"保存图片为空");
        return;
    }
    void(^changesAndWaitPhotoAlbum)(PHFetchResult<PHAsset *> *, PHAssetCollection *) = ^(PHFetchResult<PHAsset *> *createdAssets, PHAssetCollection *assetCollection){
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
            PHAssetCollectionChangeRequest *requtes = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [requtes insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
        if (error) {
            NSLog(@"图片移动到指定相册失败");
        } else {
            NSLog(@"图片移动到指定相册成功");
        }
        if (callBackBlock) {
            callBackBlock(error);
        }
    };
    
    //根据App名字获取相册, 不存在创建的新的相册
    void(^getPhotoAlbum)(PHFetchResult<PHAsset *> *, NSString *) = ^(PHFetchResult<PHAsset *> *createdAssets, NSString *photoAlbumName){
        if (photoAlbumName.length < 1) {
            photoAlbumName = [NSBundle mainBundle].infoDictionary[(__bridge NSString*)kCFBundleNameKey];
        }
        PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in collections) {
            if ([collection.localizedTitle isEqualToString:photoAlbumName]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    changesAndWaitPhotoAlbum(createdAssets, collection);
                });
                return;
            }
        }
        
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
            NSString *createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:photoAlbumName].placeholderForCreatedAssetCollection.localIdentifier;
            dispatch_async(dispatch_get_main_queue(), ^{
                PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
                if (assetCollection) {
                    changesAndWaitPhotoAlbum(createdAssets, assetCollection);
                }
            });
        } error:&error];
        if (error) {
            NSLog(@"根据App名字获取相册失败");
        } else {
            NSLog(@"根据App名字获取相册成功");
        }
        if (callBackBlock) {
            callBackBlock(error);
        }
    };
    
    //保存图片到"相机胶卷"
    void(^getPhotoFilm)(UIImage *, NSString *) = ^(UIImage *aImage, NSString *photoAlbumName){
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
            NSString *assertId =  [PHAssetChangeRequest creationRequestForAssetFromImage:aImage].placeholderForCreatedAsset.localIdentifier;
            dispatch_async(dispatch_get_main_queue(), ^{
                PHFetchResult<PHAsset *> *createdAssets = [PHAsset fetchAssetsWithLocalIdentifiers:@[assertId] options:nil];
                if (createdAssets) {
                    getPhotoAlbum(createdAssets, photoAlbumName);
                }
            });
        } error:&error];
        if (error) {
            NSLog(@"保存图片到'相机胶卷'失败");
        } else {
            NSLog(@"保存图片到'相机胶卷'成功");
        }
        if (callBackBlock) {
            callBackBlock(error);
        }
    };

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                // 用户允许当前App访问
                getPhotoFilm(aImage, aPhotoAlbumName);
            } else {
                // 无法访问相册
                NSLog(@"因系统原因，无法访问相册");
                [DPAlertView showDPMessageAlertViewForTitle:nil content:@"无法保存图片到相册，开启后即可保存图片到相册" buttonTitles:@[@"稍后开启", @"去开启权限"] buttonBlock:^BOOL(DPMessageAlertView *aObject, NSInteger tapIndex) {
                    if (tapIndex == 1) {
                        [DPPermissionsTool openApplicationSettingsWithBlock:nil];
                    }
                    return YES;
                }];
            }
        });
    }];
}

//二维码生成；aInfoP 二维码信息；aSize：图片大小，默认 CGSizeZero (原尺寸)；aLogoImage 二维码logo；aLogoType二维码类型：0 正方形，1 圆角，2 圆形；aLogoSize logo尺寸：默认 CGSizeZero (二维码1:5)
+ (UIImage *)dp_createQRCodeWithInfo:(NSString *)aInfo imageSize:(CGSize)aImageSize logoImage:(UIImage *)aLogoImage logoType:(NSInteger)aLogoType logoSize:(CGSize)aLogoSize{
    if (aInfo.length < 1) {
        return nil;
    }
    
    if (aLogoSize.width > aImageSize.width/2) {
        aLogoSize.width = aImageSize.width/2;
    }
    
    if (aLogoSize.height > aImageSize.height/2) {
        aLogoSize.height = aImageSize.height/2;
    }
    
    if (CGSizeEqualToSize(aLogoSize, CGSizeZero)) {
        aLogoSize = CGSizeMake(aImageSize.width/4, aImageSize.height/4);
    }

    //1.生成CIFilter(滤镜)对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //2.恢复滤镜默认设置
    [filter setDefaults];
    
    //3.设置数据(通过滤镜对象的KVC)
    NSData *infoData = [aInfo dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    //4.输出二维码
    CIImage *outImage = [filter outputImage];
    
    //5.高清处理: size 要大于等于视图显示的尺寸
    UIImage *image = [UIImage dp_createNonInterpolatedUIImageFromCIImage:outImage size:[UIScreen mainScreen].bounds.size.width];
    
    //6.修改尺寸
    if (!CGSizeEqualToSize(aImageSize, CGSizeZero)) {
        image = [self dp_resizeImage:image newSize:CGSizeMake(DP_FrameWidth(180), DP_FrameWidth(180))];
    }
    
    if (aLogoImage == nil) {
        return image;
    }
    
    //7.长方形裁剪为正方形
    if (aLogoImage.size.width != aLogoImage.size.height) {
        aLogoImage = [UIImage dp_image:aLogoImage fillSize:CGSizeMake(MAX(aLogoImage.size.width, aLogoImage.size.height), MAX(aLogoImage.size.width, aLogoImage.size.height))];
    }
    
    //8.logo圆角裁剪
    if (aLogoType == 1) {
        aLogoImage = [UIImage dp_CGContextClip:aLogoImage cornerRadius:6 isScale:NO];
    }else if (aLogoType == 2) {
        aLogoImage = [UIImage dp_BezierPathClip:aLogoImage cornerRadius:aLogoImage.size.width/2.00 isScale:YES borderWidth:10 borderColor:DP_RGBA(255, 255, 255, 1)];
    }
    
    //9.嵌入logo
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [aLogoImage drawInRect:CGRectMake((image.size.width-aLogoSize.width)/2.0, (image.size.height-aLogoSize.height)/2.0, aLogoSize.width, aLogoSize.height)];
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImg;
}

//图片高清处理 CGContext
+ (UIImage *)dp_createNonInterpolatedUIImageFromCIImage:(CIImage *)image size:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

//返回填充的缩略图
+ (UIImage *)dp_image:(UIImage *)image fillSize:(CGSize)viewsize {
    CGSize size = [UIImage dp_fitSize:image.size inSize:viewsize];

    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

//缩略图，计算适合的大小。并保留其原始图片大小
+ (CGSize)dp_fitSize:(CGSize)thisSize inSize:(CGSize)aSize {
    CGFloat scale;
    CGSize newsize = thisSize;
    if (newsize.height && (newsize.height > aSize.height)) {
        scale = aSize.height / newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    if (newsize.width && (newsize.width >= aSize.width)) {
        scale = aSize.width / newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    return newsize;
}

//圆角裁剪 CGContext；c 圆角半径；aIsScale 圆角半径是否自动适应分辨率，默认 NO；
+ (UIImage *)dp_CGContextClip:(UIImage *)img cornerRadius:(CGFloat)c isScale:(BOOL)aIsScale {
    if (aIsScale) {
        c = c * img.scale;
    }
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, c);
    CGContextAddArcToPoint(context, 0, 0, c, 0, c);
    CGContextAddLineToPoint(context, w-c, 0);
    CGContextAddArcToPoint(context, w, 0, w, c, c);
    CGContextAddLineToPoint(context, w, h-c);
    CGContextAddArcToPoint(context, w, h, w-c, h, c);
    CGContextAddLineToPoint(context, c, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-c, c);
    CGContextAddLineToPoint(context, 0, c);
    CGContextClosePath(context);
    
    // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    CGContextClip(context);
    // 画图
    [img drawInRect:CGRectMake(0, 0, w, h)];
    CGContextDrawPath(context, kCGPathFill);
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

//圆角裁剪 UIBezierPath；aCornerRadius 圆角半径；aIsScale 圆角半径是否自动适应分辨率，默认 NO；
+ (UIImage *)dp_BezierPathClip:(UIImage *)aImage cornerRadius:(CGFloat)aCornerRadius isScale:(BOOL)aIsScale borderWidth:(CGFloat)aBorderWidth borderColor:(UIColor *)aBorderColor {
    if (aIsScale) {
        aCornerRadius = aCornerRadius * aImage.scale;
    }
    int width = aImage.size.width * aImage.scale;
    int height = aImage.size.height * aImage.scale;
    
    //1.开启一个上下文
    CGRect bigFrame = CGRectMake(0, 0, width + 2 * aBorderWidth, height + 2 * aBorderWidth);
    UIGraphicsBeginImageContextWithOptions(bigFrame.size, NO, 0);
    //2.绘制大圆,显示出来
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:bigFrame];
    [aBorderColor set];
    [path fill];
    //3.绘制一个小圆,把小圆设置成裁剪区域
    CGRect smallFrame = CGRectMake(aBorderWidth, aBorderWidth, width, height);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:smallFrame];
    [clipPath addClip];
    //4.把图片绘制到上下文当中
    [aImage drawAtPoint:CGPointMake(aBorderWidth, aBorderWidth)];
    //5.从上下文当中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //6.关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}
@end
