//
//  FloadView.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "FloadView.h"

@interface FloadView ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageV;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageV;

@property (nonatomic,strong)CAGradientLayer * gradientL;

@end

@implementation FloadView

+ (instancetype)floadView{


    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];

}
- (void)awakeFromNib{

    [super awakeFromNib];
    //两张重叠的图片设置锚点
    self.topImageV.layer.anchorPoint = CGPointMake(0.5, 1);
    self.bottomImageV.layer.anchorPoint = CGPointMake(0.5, 0);
    //添加一个手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    //渐变图层
    CAGradientLayer * gradientL = [CAGradientLayer layer];
    gradientL.frame = self.bottomImageV.bounds;
    //渐变颜色数组
    gradientL.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    gradientL.opacity = 0;
    self.gradientL = gradientL;
    //添加到底部imageView
    [self.bottomImageV.layer addSublayer:gradientL];

}
- (void)pan:(UIPanGestureRecognizer *)pan{

    //获得手指偏移量
    CGPoint curP = [pan translationInView:self];
    //根据手指偏移量设置3D旋转角度
    CGFloat angle = - curP.y / self.frame.size.height * M_PI;
    //复位
    CATransform3D transfrom = CATransform3DIdentity;
    // 增加旋转的立体感，近大远小,d：距离图层的距离
    transfrom.m34 = -1 / 500.0;
    //3D旋转
    transfrom = CATransform3DRotate(transfrom, angle, 1, 0, 0);
    //旋转上部图片
    self.topImageV.layer.transform = transfrom;
    //设置渐变图层的透明度
    self.gradientL.opacity = curP.y * 1.0 / self.frame.size.height;
    //手势结束时
    if (pan.state == UIGestureRecognizerStateEnded) {
        //弹簧效果的物理动画
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //恢复顶部图片
            self.topImageV.layer.transform = CATransform3DIdentity;
            //隐藏渐变图层
            self.gradientL.opacity = 0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)setImage:(UIImage *)image{
    _image = image;
    //给两张图片赋值
    self.topImageV.image = _image;
    //让上部图片只显示图片的上部分
    self.topImageV.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    self.bottomImageV.image = _image;
    //让下部图片只显示图片的下部分
    self.bottomImageV.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
}

@end
