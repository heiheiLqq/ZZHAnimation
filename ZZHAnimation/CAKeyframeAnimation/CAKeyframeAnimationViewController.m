//
//  CAKeyframeAnimationViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/22.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CAKeyframeAnimationViewController.h"
#define angle2Radion(angle) (angle / 180.0 * M_PI)

@interface CAKeyframeAnimationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CAKeyframeAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    //设置需要动画的属性
    anim.keyPath = @"transform.rotation";
    //设置改变的value
    anim.values = @[@(angle2Radion(-10)),@(angle2Radion(10)),@(angle2Radion(-10))];
    
    //设置动画时间
    anim.duration = 1;
    //重复次数
    anim.repeatCount = MAXFLOAT;
    
    [self.imageView.layer addAnimation:anim forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
