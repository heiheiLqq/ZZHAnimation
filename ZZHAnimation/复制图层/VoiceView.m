//
//  VoiceView.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "VoiceView.h"

@implementation VoiceView


+ (instancetype)voiceView{

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];

}

- (void)awakeFromNib{

    [super awakeFromNib];
    //创建一个复制图层
    CAReplicatorLayer * repL = [CAReplicatorLayer layer];
    //设置复制图层的大小
    repL.frame = self.bounds;
    //添加复制图层
    [self.layer addSublayer:repL];
    //创建一个图层
    CALayer * layer = [CALayer layer];
    //设置这个的位置
    layer.position = CGPointMake(15, self.frame.size.height);
    //设置图层的锚点
    layer.anchorPoint = CGPointMake(0.5, 1);
    //设置背景颜色
    layer.backgroundColor = [UIColor grayColor].CGColor;
    //设置大小
    layer.bounds = CGRectMake(0, 0, 30, 150);
    //把这个图层添加到复制图层中
    [repL addSublayer:layer];
    //创建一个动画
    CABasicAnimation * anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale.y";
    anim.toValue = @0.1;
    anim.repeatCount = MAXFLOAT;
    //动画回到原始位置
    anim.autoreverses = YES;
    //把动画加载到layer上
    [layer addAnimation:anim forKey:nil];
    //给复制图层中子图层设置transform便宜，每个图层沿x便宜45
    repL.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    //复制4个图层 包括复制图层
    repL.instanceCount = 4;
    //每个图层一个比一个延迟一秒执行动画
    repL.instanceDelay = 0.1;
    //每个图层的颜色
    repL.instanceColor = [UIColor greenColor].CGColor;
    //每个图层颜色渐变，
    repL.instanceGreenOffset = -0.03;
}

@end
