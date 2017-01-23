//
//  CATransactionViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/22.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CATransactionViewController.h"
#define angle2radion(angle) angle / 180 * M_PI

@interface CATransactionViewController ()
@property (nonatomic,strong)CALayer * layer;
@property (nonatomic,strong)NSTimer * timer;
@end

@implementation CATransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //创建一个图层 （只有新创建的图层才可以有隐式动画）
    CALayer * layer = [[CALayer alloc] init];
    //设置大小
    layer.bounds = CGRectMake(0, 0, 80, 80);
    //设置颜色
    layer.backgroundColor = [self randomColor].CGColor;
    //设置位置点
    layer.position = CGPointMake(200, 150);
    //图层加载到view上
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self beginAnimation];
        
    }];
}
- (void)beginAnimation{
    //3D旋转
    self.layer.transform = CATransform3DMakeRotation(angle2radion(arc4random_uniform(360)), 0, 0, 1);
    //3D移动
    self.layer.position = CGPointMake(arc4random_uniform(200)+20, arc4random_uniform(400)+50);
    self.layer.cornerRadius = arc4random_uniform(50);
    self.layer.backgroundColor = [self randomColor].CGColor;
    self.layer.borderColor = [self randomColor].CGColor;
    self.layer.borderWidth = arc4random_uniform(10);
}
//随机产生颜色
- (UIColor *)randomColor{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
- (void)dealloc{

    [self.timer invalidate];
    self.timer = nil;
}

@end
