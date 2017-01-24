//
//  GooViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/24.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "GooViewController.h"
#import "ZZHGooLabel.h"
@interface GooViewController ()

@end

@implementation GooViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    ZZHGooLabel * label = [ZZHGooLabel initWithFrame:CGRectMake(0, 0, 20, 20) BackgroundColor:[UIColor redColor] andTitleColor:[UIColor whiteColor] andTitle:@"10" andFontsize:12];
//    
//    
//    label.center = self.view.center;
//    
//    [self.view addSubview:label];
    
    
    
    for (int i = 0; i < 50; i++) {
        
        CGFloat width = arc4random_uniform(50);
        
        CGFloat x = arc4random_uniform(self.view.frame.size.width);
        
        CGFloat y = arc4random_uniform(self.view.frame.size.height);
        
        int number = arc4random_uniform(100);
        
        ZZHGooLabel * label = [ZZHGooLabel initWithFrame:CGRectMake(x, y, width, width) BackgroundColor:[self randomColor] andTitleColor:[self randomColor] andTitle:[NSString stringWithFormat:@"%d",number] andFontsize:12];
        [self.view addSubview:label];
        
    }
    
    
    
}
//随机产生颜色
- (UIColor *)randomColor{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
