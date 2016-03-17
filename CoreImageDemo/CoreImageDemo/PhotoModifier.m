//
//  PhotoModifier.m
//  CoreImageDemo
//
//  Created by 陈凯 on 16/3/17.
//  Copyright © 2016年 鸥！陈凯. All rights reserved.
//

#import "PhotoModifier.h"
#import <CoreImage/CoreImage.h>

@interface PhotoModifier ()
@property (nonatomic, strong) CIContext *myContext;

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
   SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",filterName]);
    return [[PhotoModifier shareModifier] performSelector:selector withObject:image];
}
+ (instancetype)shareModifier {
    static PhotoModifier *modifier = nil;
    @synchronized(self) {
        modifier = [[PhotoModifier alloc]init];
    }
    return modifier;
}
// 褐色滤光镜
- (UIImage *)CISepiaTone:(UIImage *)img {
    
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];               // 2
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    
    [filter setValue:image forKey:kCIInputImageKey];
    
    [filter setValue:@0.9f forKey:kCIInputIntensityKey];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
    
    CGRect extent = [result extent];
    
    CGImageRef cgImage = [self.myContext createCGImage:result fromRect:extent];   // 5
    UIImage *rImg = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return rImg;
}

// 色调调整滤镜
- (UIImage *)CIHueAdjust:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];

    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@1.6f forKey:kCIInputAngleKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
    CGRect extent = [result extent];
    CGImageRef cgImage = [self.myContext createCGImage:result fromRect:extent];   // 5
    UIImage *rImg = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return rImg;
}

// 凹凸效果滤镜
- (UIImage *)CIBumpDistortion:(UIImage *)img {
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortion"];
    [filter setDefaults];
    
    [filter setValue:image forKey:kCIInputImageKey];
    [filter  setValue:[CIVector vectorWithX:img.size.width/2.0 Y:img.size.height/2.0]forKey: kCIInputCenterKey];
    [filter setValue:@(img.size.width/121.0) forKey:kCIInputScaleKey];
    [filter setValue:@(img.size.width/4) forKey:kCIInputRadiusKey];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
    CGRect extent = [result extent];
    CGImageRef cgImage = [self.myContext createCGImage:result fromRect:extent];   // 5
    UIImage *rImg = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return rImg;
}
@end
