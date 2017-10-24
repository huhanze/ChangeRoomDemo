//
//  HHBTestViewController.m
//  ChangeRoomDemo
//
//  Created by DylanHu on 2017/10/24.
//  Copyright © 2017年 DylanHu. All rights reserved.
//

#import "HHBTestViewController.h"
#import "HHBChangeView.h"
#import "UIView+HHBExtension.h"
#import "UIColor+HHBColorExtension.h"

@interface HHBTestViewController ()

@property (nonatomic, weak) HHBChangeView *changeView;

@end

@implementation HHBTestViewController
- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    HHBChangeView *changeView = [[HHBChangeView alloc] init];
    [self.view addSubview:changeView];
    self.changeView = changeView;
    changeView.offset = 100;
    changeView.needChangeRoom = YES;
    
    __block UILabel *label = [[UILabel alloc] init];
    label.text = @"上下滑动切换直播间啦";
    [changeView addSubview:label];
    label.numberOfLines = 0;
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
    closeBtn.backgroundColor = [UIColor blackColor];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self settingWithLabel:label];
    
    __weak typeof(self) weakSelf = self;
    changeView.changeRoomCompleted = ^{
        // 测试代码
        int randomNum = rand() % 100;
        label.text = [NSString stringWithFormat:@"%@ --- %d",label.text, randomNum];
        weakSelf.changeView.backgroundColor = [UIColor hb_colorFromHexRGB:[NSString stringWithFormat:@"%d%d%d%d%d%d",randomNum % 1,(randomNum / 2) % 3,randomNum * 2 % 8,randomNum % 9,(randomNum * 5) % 5,(randomNum * randomNum) % 8]];
        // 这里根据项目的需求做相应的细节处理 .........
        weakSelf.view.backgroundColor = [UIColor hb_colorFromHexRGB:[NSString stringWithFormat:@"%d%d%d%d%d%d",randomNum % 2,(randomNum/5) % 8,randomNum * 2 % 7,randomNum % 5,(randomNum * 5) % 3,(randomNum * randomNum) % 2]];
        [weakSelf settingWithLabel:label];
    };
}

#pragma mark 设置label
- (void)settingWithLabel:(UILabel *)label {
    [label sizeToFit];
    label.hb_centerX = self.changeView.hb_centerX;
    label.hb_centerY = self.changeView.hb_centerY;
    label.textColor = [UIColor orangeColor];
}

#pragma mark 退出房间
- (void)closeBtnTouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
