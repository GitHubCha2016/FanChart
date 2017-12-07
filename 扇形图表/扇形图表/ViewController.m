//
//  ViewController.m
//  扇形图表
//
//  Created by Apple on 2017/12/7.
//  Copyright © 2017年 zxl. All rights reserved.
//

#import "ViewController.h"
#import "FanChartView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FanChartView * fanChart = [[FanChartView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 130, 280, 260, 260)];
    
    fanChart.startAngle = -M_PI_2;
    fanChart.angles = @[[NSNumber numberWithInt:1],
                        
                        [NSNumber numberWithInt:2],
                        
                        [NSNumber numberWithInt:1]];
    
    [self.view addSubview:fanChart];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
