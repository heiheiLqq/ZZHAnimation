//
//  CAAnimationGroupViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/22.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CAAnimationGroupViewController.h"

@interface CAAnimationGroupViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CAAnimationGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 同时缩放，平移，旋转
    //创建一个动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    //形变动画
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @0.5;
    //旋转动画
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.toValue = @(M_PI);
    //位移动画
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"position";
    position.toValue = [NSValue valueWithCGPoint:CGPointMake(self.imageView.center.x+200,self.imageView.center.y)];
    //动画组时间
    group.duration = 2;
    //动画组重复
    group.repeatCount = MAXFLOAT;
    //三个基本动画添加到动画组中
    group.animations = @[scale,rotation,position];
    [self.imageView.layer addAnimation:group forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
