//
//  DrawView.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/22.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()
@property (nonatomic,strong)UIBezierPath * path;
@end


@implementation DrawView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取touch对象
    UITouch * touch = [touches anyObject];
    //获取手指位置
    CGPoint fingerP = [touch locationInView:self];
    //创建一个路径并保存
    UIBezierPath * path = [UIBezierPath bezierPath];
    self.path = path;
    //路径添加起点
    [path moveToPoint:fingerP];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint fingerP = [touch locationInView:self];
    //不断连线，
    [self.path addLineToPoint:fingerP];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//创建一个帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    //动画需要改变的属性
    anim.keyPath = @"position";
    //动画的改变的路径
    anim.path = _path.CGPath;
    //动画的时间
    anim.duration = 1;
    //动画的重复次数
    anim.repeatCount = MAXFLOAT;
    [[[self.subviews firstObject] layer] addAnimation:anim forKey:nil];
}

- (void)drawRect:(CGRect)rect{
    //划线
    [self.path stroke];
}
@end
