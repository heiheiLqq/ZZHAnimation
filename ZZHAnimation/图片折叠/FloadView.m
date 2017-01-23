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
    
    
    self.topImageV.layer.anchorPoint = CGPointMake(0.5, 1);
    
    self.bottomImageV.layer.anchorPoint = CGPointMake(0.5, 0);

    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
    
    CAGradientLayer * gradientL = [CAGradientLayer layer];
    
    gradientL.frame = self.bottomImageV.bounds;
    
    gradientL.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
    
    gradientL.opacity = 0;

    self.gradientL = gradientL;
    
    [self.bottomImageV.layer addSublayer:gradientL];

}
- (void)pan:(UIPanGestureRecognizer *)pan{


    CGPoint curP = [pan translationInView:self];
    
    CGFloat angle = - curP.y / self.frame.size.height * M_PI;
    
    CATransform3D transfrom = CATransform3DIdentity;
    
    
    // 增加旋转的立体感，近大远小,d：距离图层的距离
    transfrom.m34 = -1 / 500.0;
    
    transfrom = CATransform3DRotate(transfrom, angle, 1, 0, 0);
    
    self.topImageV.layer.transform = transfrom;
    
    self.gradientL.opacity = curP.y * 1.0 / self.frame.size.height;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.topImageV.layer.transform = CATransform3DIdentity;

            
            self.gradientL.opacity = 0;
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
    

}

- (void)setImage:(UIImage *)image{

    _image = image;
    
    self.topImageV.image = _image;
    
    self.topImageV.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    
   
    self.bottomImageV.image = _image;
    
    self.bottomImageV.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
   

}

@end
