//
//  ViewController.m
//  FMTopReflesh
//
//  Created by 李传格 on 16/6/25.
//  Copyright © 2016年 lichuange. All rights reserved.
//

#import "ViewController.h"
#import "FMTopRefleshControl.h"
#import "CustomTopRefleshView.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FMTopRefleshControl *refleshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = self.view.bounds;
    
    UITableView *v = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    v.delegate = self;
    v.dataSource = self;
    if (@available(iOS 11.0, *)) {
        v.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        v.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    } else {
        // Fallback on earlier versions
    }
    [v registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:v];
 
    
    self.refleshControl = [[FMTopRefleshControl alloc] initWithScrollView:v withRefleshCallback:^(FMTopRefleshControl *control) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [control endReflesh];
        });
    }];
    
//    self.refleshControl = [[FMTopRefleshControl alloc] initWithScrollView:v withRefleshCallback:^(FMTopRefleshControl *control) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [control endReflesh];
//        });
//    } withTopView:[[CustomTopRefleshView alloc] initWithFrame:CGRectMake(0, 0, 400, 64)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    
    return cell;
}

@end
