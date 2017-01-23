//
//  TurnBtn.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "TurnBtn.h"

@implementation TurnBtn

// 寻找最合适的view（设置按钮重合的位置不能被点击）
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat btnW = self.bounds.size.width;
    CGFloat btnH = self.bounds.size.height;
    
    CGFloat x = 0;
    CGFloat y = btnH / 2;
    CGFloat w = btnW;
    CGFloat h = y;
    CGRect rect = CGRectMake(x, y, w, h);
    if (CGRectContainsPoint(rect, point)) {
        return nil;
    }else{
        return [super hitTest:point withEvent:event];
    }
    
}

// 设置UIImageView的尺寸
// contentRect:按钮的尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    // 计算UIImageView控件尺寸
    CGFloat imageW = 40;
    CGFloat imageH = 46;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = 20;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

// 取消高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end
