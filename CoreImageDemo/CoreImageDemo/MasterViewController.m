//
//  MasterViewController.m
//  CoreImageDemo
//
//  Created by 陈凯 on 16/3/16.
//  Copyright © 2016年 鸥！陈凯. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%@",[[CIFilter filterWithName:@"CIAffineClamp"] attributes]);
    
    NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryBuiltIn]);
    self.objects = [NSMutableArray new];
    // 模糊效果
    [self.objects addObject:[@{@"data":@[@"CIBoxBlur",@"CIDiscBlur",@"CIGaussianBlur",@"CIMedianFilter",@"CIZoomBlur"],@"isOpen":@YES,@"title":@"模糊效果"} mutableCopy]];
    // 内建滤镜
    [self.objects addObject:[@{@"data":@[@"CISepiaTone",@"CIHueAdjust",@"CIBumpDistortion",@"CIAccordionFoldTransition",@"CIAdditionCompositing",@"CIAffineClamp"],@"isOpen":@YES,@"title":@"内建预置滤镜效果"} mutableCopy]];
    // Do any additional setup after loading the view, typically from a nib.

    

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *filterName = [self.objects[indexPath.section][@"data"] objectAtIndex:indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:filterName];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    view.tag = 1000 + section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSection:)];
    [view addGestureRecognizer:tap];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
    label.text = self.objects[section][@"title"];
    label.font = [UIFont systemFontOfSize:22];
    [view addSubview:label];
    return view;
}
- (void)tapSection:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag - 1000;
    if ([self.objects[section][@"isOpen"] boolValue]) {
        self.objects[section][@"isOpen"] = @NO;
    }else {
        self.objects[section][@"isOpen"] = @YES;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.objects[section][@"isOpen"] boolValue]) {
        return [self.objects[section][@"data"] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *object = [self.objects[indexPath.section][@"data"] objectAtIndex:indexPath.row];;
    cell.textLabel.text = [object description];
    return cell;
}




@end
