//
//  ViewController.m
//  ChangeRoomDemo
//
//  Created by DylanHu on 2017/10/20.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "ViewController.h"
#import "HHBTestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)btnDidClicked:(id)sender {
    HHBTestViewController *testVC = [[HHBTestViewController alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
