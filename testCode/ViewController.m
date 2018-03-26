//
//  ViewController.m
//  testCode
//
//  Created by YeYiFeng on 2018/3/26.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "ViewController.h"
#import "person.h"
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   person * p1 = [[person alloc]init];
    [p1 run];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
