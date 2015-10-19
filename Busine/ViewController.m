//
//  ViewController.m
//  businessNeed
//
//  Created by 黄剛 on 2015/08/19.
//  Copyright (c) 2015年 黄剛. All rights reserved.
//

#import "ViewController.h"
#import "BussinessNeedController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initView{
    int height = self.view.frame.size.height;
    int width = self.view.frame.size.width;
    UIButton *bussinessNeedButton = [[UIButton alloc] init];
    bussinessNeedButton.frame = CGRectMake(width*.1, height*.1, width*.2, height*.1);
    bussinessNeedButton.backgroundColor = [UIColor redColor];
    [bussinessNeedButton setTitle:@"商务需求" forState:UIControlStateNormal];
    [bussinessNeedButton addTarget:self action:@selector(gotoBussinessNeed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bussinessNeedButton];
}
-(void) gotoBussinessNeed{
    BussinessNeedController *bnController = [[BussinessNeedController alloc] init];
    [self.navigationController pushViewController:bnController animated:YES];
}

@end
