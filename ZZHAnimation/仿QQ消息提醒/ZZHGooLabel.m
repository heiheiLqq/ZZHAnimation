//
//  ZZHGooLabel.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/24.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ZZHGooLabel.h"
#define kMaxDistance 80

@interface ZZHGooLabel ()

@property (nonatomic,strong)UIView * backSmallView;

@property (nonatomic, weak) CAShapeLayer *shapeLayer;


@end


@implementation ZZHGooLabel

+ (instancetype)initWithFrame:(CGRect )frame BackgroundColor:(UIColor *)backColor andTitleColor:(UIColor *)titleColor andTitle:(NSString *)title andFontsize:(CGFloat)font{

    
    
    ZZHGooLabel * label = [[self alloc]initWithFrame:frame];
    
    label.gooBackGroundColor = backColor;
    
    label.titleColor = titleColor;
    
    label.title = title;
    
    label.titleFont = font;
    
    [label setup];
    
    return label;

}



- (void)layoutSubviews{

    CGFloat h = self.bounds.size.height;

    self.backSmallView.center = self.center;
    self.backSmallView.bounds = self.bounds;
    self.backSmallView.layer.cornerRadius = h / 2;

}
- (void)setup{

    CGFloat h = self.bounds.size.height;
    
    self.textAlignment = NSTextAlignmentCenter;
    
    self.layer.cornerRadius = h * 0.5;
    
    self.clipsToBounds = YES;
    
    self.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
    
    
}



- (void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint tranP = [pan translationInView:self];
    
    CGPoint center = self.center;
    
    center.x += tranP.x;
    
    center.y += tranP.y;
    
    self.center = center;
    
    [pan setTranslation:CGPointZero inView:self];
    
    CGFloat d = [self circleCenterDistanceWithBigCircleCenter:self.center smallCircleCenter:self.backSmallView.center];

    CGFloat h = self.bounds.size.height*0.5;
    CGFloat smallRadius = h - d / 10;
    self.backSmallView.bounds = CGRectMake(0, 0, smallRadius * 2, smallRadius * 2);
    self.backSmallView.layer.cornerRadius = smallRadius;


//    if (d) {
//        // 展示不规则矩形，通过不规则矩形路径生成一个图层
//        
//        self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:self.backSmallView].CGPath;
//        
//    }
    
    if (d > kMaxDistance) { // 可以拖出来
        // 隐藏小圆
        self.backSmallView.hidden = YES;
        
        // 移除不规则的矩形
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        
    }else if(d > 0 && self.backSmallView.hidden == NO){ // 有圆心距离，并且圆心距离不大，才需要展示
        // 展示不规则矩形，通过不规则矩形路径生成一个图层
        
        self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:self.backSmallView].CGPath;
    }
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        // 当圆心距离大于最大圆心距离
        if (d > kMaxDistance) {
            // 展示gif动画
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            NSMutableArray *arrM = [NSMutableArray array];
            for (int i = 11; i < 19; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
                [arrM addObject:image];
            }
            imageView.animationImages = arrM;
            
            imageView.animationRepeatCount = 1;
            
            imageView.animationDuration = 0.5;
            
            [imageView startAnimating];
            
            [self addSubview:imageView];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
            
        }else{
            
            // 移除不规则矩形
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            // 还原位置
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                // 设置大圆中心点位置
                self.center = self.backSmallView.center;
                
            } completion:^(BOOL finished) {
                // 显示小圆
                self.backSmallView.hidden = NO;
            }];
            
        }
        
    }

}

- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        // 展示不规则矩形，通过不规则矩形路径生成一个图层
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        _shapeLayer = layer;
        
        layer.fillColor = self.backgroundColor.CGColor;
        
        [self.superview.layer insertSublayer:layer below:self.layer];
        
    }
    
    return _shapeLayer;
}
- (UIView *)backSmallView{

    if (!_backSmallView) {
        
        UIView * view = [[UIView alloc] init];
        
        view.backgroundColor = self.backgroundColor;
        
        _backSmallView = view;
        
        [self.superview insertSubview:_backSmallView belowSubview:self];
        
    }

    return _backSmallView;

}


#pragma mark - 重写set
- (void)setTitleFont:(CGFloat)titleFont{

    _titleFont = titleFont;
    
    self.font = [UIFont systemFontOfSize:titleFont];

}

- (void)setGooBackGroundColor:(UIColor *)gooBackGroundColor{

    _gooBackGroundColor = gooBackGroundColor;
    
    self.backgroundColor = _gooBackGroundColor;

}

- (void)setTitle:(NSString *)title{

    _title = title;
    
    self.text = _title;
    
}

- (void)setTitleColor:(UIColor *)titleColor{

    _titleColor = titleColor;
    
    self.textColor = titleColor;
}

// 描述两圆之间一条矩形路径
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView
{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    
    
    
    // 获取圆心距离
    CGFloat d = [self circleCenterDistanceWithBigCircleCenter:bigCenter smallCircleCenter:smallCenter];
    
    CGFloat sinθ = (x2 - x1) / d;
    
    CGFloat cosθ = (y2 - y1) / d;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP =  CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // A
    [path moveToPoint:pointA];
    
    // AB
    [path addLineToPoint:pointB];
    
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    
    // CD
    [path addLineToPoint:pointD];
    
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
    
}
// 计算两个圆心之间的距离
- (CGFloat)circleCenterDistanceWithBigCircleCenter:(CGPoint)bigCircleCenter smallCircleCenter:(CGPoint)smallCircleCenter
{
    CGFloat offsetX = bigCircleCenter.x - smallCircleCenter.x;
    CGFloat offsetY = bigCircleCenter.y - smallCircleCenter.y;
    
    return  sqrt(offsetX * offsetX + offsetY * offsetY);
}

@end
