//
//  PhotoModifier.m
//  CoreImageDemo
//
//  Created by 陈凯 on 16/3/17.
//  Copyright © 2016年 鸥！陈凯. All rights reserved.
//

#import "PhotoModifier.h"
#import <CoreImage/CoreImage.h>
#import <objc/objc-runtime.h>
@interface PhotoModifier ()
@property (nonatomic, strong) CIContext *myContext;
@property (nonatomic, strong) CIFilter *filter;

@end
@implementation PhotoModifier
- (CIContext *)myContext {
    if (_myContext == nil) {
        NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
        EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        _myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    }
    return _myContext;
}
+ (UIImage *)modifyImage:(UIImage *)image WithFilterName:(NSString *)filterName {
    [[PhotoModifier shareModifier]setFilterName:filterName];
    NSString *selectorName = [NSString stringWithFormat:@"%@:",filterName];
    
    return objc_msgSend([PhotoModifier shareModifier],sel_registerName(selectorName.UTF8String),image);
}
+ (instancetype)shareModifier {
    static PhotoModifier *modifier = nil;
    @synchronized(self) {
        if (modifier == nil) {
            modifier = [[PhotoModifier alloc]init];
        }
    }
    return modifier;
}
#pragma mark getter FilterName 
- (void)setFilterName:(NSString *)name {
    self.filter = [CIFilter filterWithName:name];
    [self.filter setDefaults];
}
- (UIImage *)getImage:(CIImage *)ciImg {
    CGRect extent = ciImg.extent;
    CGImageRef rImage = [self.myContext createCGImage:ciImg fromRect:extent];
    UIImage *rImg = [UIImage imageWithCGImage:rImage];
    CGImageRelease(rImage);
    return rImg;
}
#pragma mark - 模糊效果 Blur
// CIBoxBlur均值模糊
- (UIImage *)CIBoxBlur:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter setValue:@17.1f forKey:kCIInputRadiusKey];
    
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];

    return [self getImage:result];
}
// 圆盘形状内模糊化图像
- (UIImage *)CIDiscBlur:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];

    [self.filter setValue:image forKey:kCIInputImageKey];
    [self. filter setValue:@10.0f forKey:kCIInputRadiusKey];
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];
   
    return [self getImage:result];
}
// 高斯模糊
- (UIImage *)CIGaussianBlur:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter setValue:@17.0f forKey:kCIInputRadiusKey];
    
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];
    
    return [self getImage:result];
}
// 差值模糊
- (UIImage *)CIMedianFilter:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    CIImage *rImg = [self.filter valueForKey:kCIOutputImageKey];
    return [self getImage:rImg];
}

// Zoom模糊 聚焦拉伸
- (UIImage *)CIZoomBlur:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter setValue:[CIVector vectorWithX:img.size.width/2.0 Y:img.size.height/2.0] forKey:kCIInputCenterKey];
    [self.filter setValue:@7.0 forKey:@"inputAmount"];
    
    CIImage *rImage = [self.filter valueForKey:kCIOutputImageKey];
    return [self getImage:rImage];
}
// 褐色滤光镜
- (UIImage *)CISepiaTone:(UIImage *)img {
    
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    
    [self.filter setValue:@0.9f forKey:kCIInputIntensityKey];
    
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];
    
    return [self getImage:result];
}

// 色调调整滤镜
- (UIImage *)CIHueAdjust:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
   
    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter setValue:@1.6f forKey:kCIInputAngleKey];
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];
    return [self getImage:result];
}

// 凹凸效果滤镜
- (UIImage *)CIBumpDistortion:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter  setValue:[CIVector vectorWithX:img.size.width/2.0 Y:img.size.height/2.0]forKey: kCIInputCenterKey];
    [self.filter setValue:@(img.size.width/121.0) forKey:kCIInputScaleKey];
    [self.filter setValue:@(img.size.width/4) forKey:kCIInputRadiusKey];
    
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];

    return [self getImage:result];
}

// 褶皱过度
- (UIImage *)CIAccordionFoldTransition:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    UIImage *targetImg = [UIImage imageNamed:@"sunli.jpeg"];
    CIImage *targetImage = [CIImage imageWithCGImage:targetImg.CGImage];

    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter setValue:targetImage forKey:kCIInputTargetImageKey];
    [self.filter setValue:@(0.5) forKey:kCIInputTimeKey];

    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];

    return [self getImage:result];
}
// 图形叠加效果
- (UIImage *)CIAdditionCompositing:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    UIImage *targetImg = [UIImage imageNamed:@"sunli.jpeg"];
    CIImage *targetImage = [CIImage imageWithCGImage:targetImg.CGImage];
    [self.filter setValue:targetImage forKey:kCIInputImageKey];
    [self.filter setValue:image forKey:kCIInputBackgroundImageKey];
    
    CIImage *rImage = [self.filter valueForKey:kCIOutputImageKey];
    return [self getImage:rImage];
}

// 仿射变换滤摬
- (UIImage *)CIAffineClamp:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    CGAffineTransform xform = CGAffineTransformMake(0.7, 0, 0.5, 0.7, 100, 0);
    [self.filter setValue:[NSValue valueWithBytes:&xform
                                         objCType:@encode(CGAffineTransform)] forKey:kCIInputTransformKey];
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];
    
    CGImageRef rImage = [self.myContext createCGImage:result fromRect:CGRectMake(0, 0,img.size.width, img.size.height)];
    UIImage *rImg = [UIImage imageWithCGImage:rImage];
    CGImageRelease(rImage);
    return rImg;
}

// CIColorClamp颜色调整
- (UIImage *)CIColorClamp:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    [self.filter setValue:[CIVector vectorWithX:0.9 Y:0.7 Z:0.6 W:1] forKey:@"inputMaxComponents"];
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];
    
    return [self getImage:result];
}

// CIAffineTile循环多图
- (UIImage *)CIAffineTile:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    
    [self.filter setValue:image forKey:kCIInputImageKey];
    CGAffineTransform xform = CGAffineTransformMake(0.2, 0, 0, 0.2, 100, 0);
    [self.filter setValue:[NSValue valueWithBytes:&xform
                                         objCType:@encode(CGAffineTransform)] forKey:kCIInputTransformKey];
    CIImage *result = [self.filter valueForKey:kCIOutputImageKey];
    
    CGImageRef rImage = [self.myContext createCGImage:result fromRect:CGRectMake(0, 0,img.size.width, img.size.height)];
    UIImage *rImg = [UIImage imageWithCGImage:rImage];
    CGImageRelease(rImage);
    return rImg;
}
@end
