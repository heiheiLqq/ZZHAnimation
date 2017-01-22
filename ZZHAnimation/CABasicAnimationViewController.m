//
//  CABasicAnimationViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/22.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CABasicAnimationViewController.h"

@interface CABasicAnimationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *positionImageV;
@property (weak, nonatomic) IBOutlet UIImageView *scaleImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rotationImageV;

@end

@implementation CABasicAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    CABasicAnimation * positionAnim = [CABasicAnimation animation];
    
    positionAnim.keyPath = @"position";
    
    positionAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.positionImageV.center.x+200, self.positionImageV.center.y)];
    // 设置动画执行次数
    positionAnim.repeatCount = MAXFLOAT;
    
    // 取消动画反弹
    // 设置动画完成的时候不要移除动画
    positionAnim.removedOnCompletion = NO;
    
    // 设置动画执行完成要保持最新的效果
    positionAnim.fillMode = kCAFillModeForwards;
    
    positionAnim.duration =2;
    
    [self.positionImageV.layer addAnimation:positionAnim forKey:nil];
    
    //创建一个基本动画
    CABasicAnimation * scaleAnim = [CABasicAnimation animation];
    //kvc设置需要动画的属性
    scaleAnim.keyPath = @"transform.scale";
    //设置该属性的最终装填
    scaleAnim.toValue = @0.5;
    // 设置动画执行次数
    scaleAnim.repeatCount = MAXFLOAT;
    
    // 取消动画反弹
    // 设置动画完成的时候不要移除动画
    scaleAnim.removedOnCompletion = NO;
    
    // 设置动画执行完成要保持最新的效果
    scaleAnim.fillMode = kCAFillModeForwards;
    //设置动画时间
    scaleAnim.duration =2;
    
    [self.scaleImageV.layer addAnimation:scaleAnim forKey:nil];
    
    
    CABasicAnimation * rotationAnim = [CABasicAnimation animation];
    
    rotationAnim.keyPath = @"transform.rotation";
    
    rotationAnim.toValue = @M_PI;
    // 设置动画执行次数
    rotationAnim.repeatCount = MAXFLOAT;
    
    // 取消动画反弹
    // 设置动画完成的时候不要移除动画
    rotationAnim.removedOnCompletion = NO;
    
    // 设置动画执行完成要保持最新的效果
    rotationAnim.fillMode = kCAFillModeForwards;
    
    rotationAnim.duration =2;
    
    [self.rotationImageV.layer addAnimation:rotationAnim forKey:nil];
    


}



@end
