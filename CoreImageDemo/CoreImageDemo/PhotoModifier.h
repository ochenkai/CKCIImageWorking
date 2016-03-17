//
//  PhotoModifier.h
//  CoreImageDemo
//
//  Created by 陈凯 on 16/3/17.
//  Copyright © 2016年 鸥！陈凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PhotoModifier : NSObject
+ (UIImage *)modifyImage:(UIImage *)image WithFilterName:(NSString *)filterName;
@end
