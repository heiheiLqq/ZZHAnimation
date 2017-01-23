//
//  CaTransitionViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/22.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CAAnimationViewController.h"

@interface CAAnimationViewController ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CAAnimationViewController

- (void)change{
    // 转场代码
    if (i == 4) {
        i = 1;
    }
    // 加载图片名称
    NSString *imageN = [NSString stringWithFormat:@"%d",i];
    
    _imageView.image = [UIImage imageNamed:imageN];
    i++;
    // 转场动画
    CATransition *anim = [CATransition animation];
    //动画设置代理
    anim.delegate = self;
    //动画类型 苹果封装好多种类型
    anim.type = @"pageCurl";
    anim.duration = 2;
    [_imageView.layer addAnimation:anim forKey:nil];


}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self change];
}

static int i = 2;
//动画结束时调用
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    [self change];

}


@end
