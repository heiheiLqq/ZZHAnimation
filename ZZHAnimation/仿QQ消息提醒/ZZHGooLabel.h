//
//  ZZHGooLabel.h
//  ZZHAnimation
//
//  Created by zzh on 2017/1/24.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZHGooLabel : UILabel
//背景色
@property (nonatomic,strong)UIColor * gooBackGroundColor;
//文字颜色
@property (nonatomic,strong)UIColor * titleColor;
//文字内容
@property (nonatomic,strong)NSString * title;

//字体大小
@property (nonatomic ,assign)CGFloat titleFont;

//初始化类方法
+ (instancetype)initWithFrame:(CGRect )frame BackgroundColor:(UIColor *)backColor andTitleColor:(UIColor *)titleColor andTitle:(NSString *)title andFontsize:(CGFloat)font;
@end
