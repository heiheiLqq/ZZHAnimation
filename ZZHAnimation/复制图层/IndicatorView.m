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
    
    CAReplicatorLayer * repL = [CAReplicatorLayer layer];
    
    repL.frame = self.bounds;
    
    [self.layer addSublayer:repL];
    
    CALayer * layer = [CALayer layer];
    
    layer.position = CGPointMake(self.frame.size.width * 0.5, 10);
    
    layer.bounds = CGRectMake(0, 0, 5, 5);
    
    layer.backgroundColor = [UIColor purpleColor].CGColor;
    
    layer.transform = CATransform3DMakeScale(0, 0, 0);
    
    [repL addSublayer:layer];
    
    CABasicAnimation * anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.scale";
    
    anim.fromValue = @1;
    
    anim.toValue = @0;
    
    anim.repeatCount = MAXFLOAT;
    
    CGFloat duration = 1;

    anim.duration = duration;
    
    [layer addAnimation:anim forKey:nil];
    
    int count = 20;
    
    repL.instanceCount = count;
    
    repL.instanceDelay = duration / count;
    
    CGFloat angle = M_PI * 2 / count;
    
    repL.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    

}

@end
