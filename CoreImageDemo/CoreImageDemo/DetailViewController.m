//
//  DetailViewController.m
//  CoreImageDemo
//
//  Created by 陈凯 on 16/3/16.
//  Copyright © 2016年 鸥！陈凯. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoModifier.h"
@interface DetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.title = self.detailItem;
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}
- (IBAction)tapImageViewGesture:(id)sender {
    // 点击ImageView弹出选图
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
// 代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    NSLog(@"%@",image);
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self configFilter];
}
- (void)configFilter {
    UIImage *image = self.imageView.image;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *reImage = [PhotoModifier modifyImage:image WithFilterName:self.detailItem];
        self.imageView.image = reImage;
    });

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
