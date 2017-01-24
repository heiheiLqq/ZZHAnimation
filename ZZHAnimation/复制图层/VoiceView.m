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
    
    
    CAReplicatorLayer * repL = [CAReplicatorLayer layer];
    
    repL.frame = self.bounds;
    
    [self.layer addSublayer:repL];
    
    CALayer * layer = [CALayer layer];
    
    layer.position = CGPointMake(15, self.frame.size.height);
    
    layer.anchorPoint = CGPointMake(0.5, 1);
    
    layer.backgroundColor = [UIColor grayColor].CGColor;
    
    layer.bounds = CGRectMake(0, 0, 30, 150);
    
    [repL addSublayer:layer];
    
    CABasicAnimation * anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.scale.y";
    
    anim.toValue = @0.1;
    
    anim.repeatCount = MAXFLOAT;
    
    anim.autoreverses = YES;
    
    [layer addAnimation:anim forKey:nil];
    
    repL.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    
    repL.instanceCount = 4;
    
    repL.instanceDelay = 0.1;
    
    repL.instanceColor = [UIColor greenColor].CGColor;
    
    repL.instanceGreenOffset = -0.03;

    

}

@end
