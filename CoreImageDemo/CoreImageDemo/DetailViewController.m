//
//  DetailViewController.m
//  CoreImageDemo
//
//  Created by 陈凯 on 16/3/16.
//  Copyright © 2016年 鸥！陈凯. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoModifier.h"
#import "MBProgressHUD.h"
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
        self.imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.imageView.layer.borderWidth = 1;
    }
}
- (IBAction)tapImageViewGesture:(id)sender {
    NSLog(@"tap");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self performSelectorInBackground:@selector(configFilter) withObject:nil];
}
- (void)configFilter {

    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *reImage = [PhotoModifier modifyImage:self.imageView.image WithFilterName:self.detailItem];
            self.imageView.image = reImage;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
