//
//  TurntableViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "TurntableViewController.h"
#import "TurntableView.h"
@interface TurntableViewController ()
@property (nonatomic,strong)TurntableView * turnView;
@end

@implementation TurntableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //封装一个自定义的view
    TurntableView * turnView = [TurntableView turnTableView];
    turnView.center = self.view.center;
    self.turnView = turnView;
    [self.view addSubview:turnView];

}
#pragma mark - 转盘开始转动点击事件
- (IBAction)start:(id)sender {
    [self.turnView start];
}
#pragma mark - 转盘暂停转动
- (IBAction)puarse:(id)sender {
    [self.turnView purase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
