//
//  FoldPhotoViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "FoldPhotoViewController.h"
#import "FloadView.h"
@interface FoldPhotoViewController ()

@end

@implementation FoldPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FloadView * floadView = [FloadView floadView];
    floadView.center = self.view.center;
    floadView.image = [UIImage imageNamed:@"小新"];
    [self.view addSubview:floadView];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
