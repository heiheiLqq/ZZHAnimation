//
//  IndicatorView.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView

+ (instancetype)indicatorView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    
}

- (void)awakeFromNib{

    [super awakeFromNib];
    //创建一个复制图层
    CAReplicatorLayer * repL = [CAReplicatorLayer layer];
    //设置图层的的大小
    repL.frame = self.bounds;
    //添加复制图层
    [self.layer addSublayer:repL];
    //创建一个子图层
    CALayer * layer = [CALayer layer];
    //设置初始位置
    layer.position = CGPointMake(self.frame.size.width * 0.5, 10);
    //设置子图层大小
    layer.bounds = CGRectMake(0, 0, 5, 5);
    //设置图层的背景颜色
    layer.backgroundColor = [UIColor purpleColor].CGColor;
    //默认形变为0是不显示的
    layer.transform = CATransform3DMakeScale(0, 0, 0);
    //把图层添加到复制图层中
    [repL addSublayer:layer];
    //创建一个动画
    CABasicAnimation * anim = [CABasicAnimation animation];
    //设置形变
    anim.keyPath = @"transform.scale";
    anim.fromValue = @1;
    anim.toValue = @0;
    anim.repeatCount = MAXFLOAT;
    CGFloat duration = 1;
    anim.duration = duration;
    [layer addAnimation:anim forKey:nil];
    int count = 20;
    //20个子图层
    repL.instanceCount = count;
    repL.instanceDelay = duration / count;
    //每个子图层transform旋转偏移
    CGFloat angle = M_PI * 2 / count;
    repL.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

@end
