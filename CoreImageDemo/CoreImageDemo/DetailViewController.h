//
//  DetailViewController.h
//  CoreImageDemo
//
//  Created by 陈凯 on 16/3/16.
//  Copyright © 2016年 鸥！陈凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

