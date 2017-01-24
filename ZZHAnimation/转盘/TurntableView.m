//
//  TurntableView.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "TurntableView.h"
#import "TurnBtn.h"

@interface TurntableView ()<CAAnimationDelegate>

@property (nonatomic,strong)TurnBtn * btn;
@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
@property (nonatomic,strong)CADisplayLink * link;
@property (weak, nonatomic) IBOutlet UIImageView *rotationView;
@end

@implementation TurntableView
#pragma mark - 初始化xib控件
+ (instancetype)turnTableView{


    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];

}
#pragma mark - xib加载后创建12个按钮
- (void)awakeFromNib{
    [super awakeFromNib];
    //设置按钮父控件可以交互
    self.rotationView.userInteractionEnabled = YES;
    //按钮的宽高
    CGFloat btnW = 68;
    CGFloat btnH = 143;
    //view的宽高
    CGFloat wh = self.bounds.size.width;
    //12张按钮图片是连一起的一张大图 需要裁剪
    UIImage *bigImage = [UIImage imageNamed:@"LuckyAstrology"];
    //select状太下的图片
    UIImage *selBigImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    //获取像素与点的比值
    CGFloat scale = [UIScreen mainScreen].scale;
    //每个图片的宽度
    CGFloat imageW = bigImage.size.width / 12 * scale;
    //每个图片的高度
    CGFloat imageH = bigImage.size.height * scale;
    for (int i = 0; i < 12; i ++) {
        //每个图片需要旋转的角度
        CGFloat angle = (30 * i) / 180.0 * M_PI;
        //自定义按钮
        TurnBtn * btn = [TurnBtn buttonWithType:UIButtonTypeCustom];
        //大小
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        //设置position 和anchorPoint 因为要旋转每个按钮
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = CGPointMake(wh*0.5, wh*0.5);
        //旋转angle
        btn.transform = CGAffineTransformMakeRotation(angle);
        [self.rotationView addSubview:btn];
        //图片裁剪区域
        CGRect clipR = CGRectMake(i * imageW, 0, imageW, imageH);
        //获得裁剪后的图片
        CGImageRef imgR =  CGImageCreateWithImageInRect(bigImage.CGImage, clipR);
        //转成UIImage
        UIImage *image = [UIImage imageWithCGImage:imgR];
        [btn setImage:image forState:UIControlStateNormal];
        imgR = CGImageCreateWithImageInRect(selBigImage.CGImage, clipR);
        image = [UIImage imageWithCGImage:imgR];
        [btn setImage:image forState:UIControlStateSelected];
        //设置背景图
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            //默认选中第一张
            [self btnClick:btn];
        }
    }
}
#pragma mark - 按钮点击
- (void)btnClick:(TurnBtn *)btn{


    //选中点击的按钮
    btn.selected = YES;
    //之前记录的选中按钮取消选中
    self.btn.selected = NO;
    //记录当前选中按钮
    self.btn = btn;

}
#pragma mark -选号点击
- (IBAction)pickerClick:(id)sender {
    // 不需要定时器旋转
    self.link.paused = YES;
    // 中间的转盘快速的旋转，并且不需要与用户交互
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI * 2 * 3);
    anim.duration = 0.5;
    anim.delegate = self;
    [self.rotationView.layer addAnimation:anim forKey:nil];
    // 点击哪个星座，就把当前星座指向中心点上面
    // M_PI 3.14
    // 根据选中的按钮获取旋转的度数,
    // 通过transform获取角度
    CGFloat angle = atan2(self.btn.transform.b, self.btn.transform.a);
    // 旋转转盘
    self.rotationView.transform = CGAffineTransformMakeRotation(-angle);
}
#pragma mark -定时器懒加载
// 1.搞个定时器，每隔一段时间就旋转一定的角度，1秒旋转45°
- (CADisplayLink *)link{
    if (!_link) {
        //CADisplayLink 定时器一秒调用60次
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation)];
        //讲定时器添加到驻训华
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}
#pragma mark - 定时器绑定的旋转方法
- (void)rotation{
    // 每一次调用旋转多少 45 \ 60.0
    CGFloat angle = (45 / 60.0) * M_PI / 180.0;
    self.rotationView.transform = CGAffineTransformRotate(self.rotationView.transform, angle);
}
#pragma mark - 开始旋转的方法
- (void)start{
    self.link.paused = NO;
}
#pragma mark - 暂停旋转的方法
- (void)purase {
    self.link.paused = YES;
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.link.paused = NO;
    });
}
@end
