//
//  ViewController.m
//  ChartsTest
//
//  Created by 周灿华 on 2017/10/17.
//  Copyright © 2017年 周灿华. All rights reserved.
//

#import "ViewController.h"
#import "XZPieChartView.h"

@interface ViewController ()

/** 饼图 */
@property (nonatomic, strong) XZPieChartView *pieView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pieView = [[XZPieChartView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 250) configBlock:^(XZPieChartViewConfig *config) {
        //设置数据和一些样式
        config.backgroundColor = [UIColor lightGrayColor];
        config.titles = @[
                          @"一月份",
                          @"二月份",
                          @"三月份",
                          @"四月份",
                          @"五月份",
                          @"六月份"
                          ];
        
        config.values = @[
                          @"320",
                          @"666",
                          @"1000",
                          @"480",
                          @"590",
                          @"888"
                          ];
    }];
    [self.view addSubview:_pieView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
