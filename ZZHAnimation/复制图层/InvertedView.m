//
//  InvertedView.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/24.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "InvertedView.h"

@interface InvertedView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation InvertedView
+ (Class)layerClass
{
    return [CAReplicatorLayer class];
}
+ (instancetype)invertedView{

    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];

}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    
    
    
    CAReplicatorLayer *layer =  (CAReplicatorLayer *)self.layer;
    
    layer.anchorPoint = CGPointMake(0.5, 1);
    
    layer.instanceCount = 3;
    
    // 往下面平移控件的高度
    layer.instanceTransform = CATransform3DMakeRotation(M_PI*0.5, 1, 0, 0);
    
    layer.instanceAlphaOffset = -0.1;
    layer.instanceBlueOffset = -0.1;
    layer.instanceGreenOffset = -0.1;
    layer.instanceRedOffset = -0.1;
    
}

@end
