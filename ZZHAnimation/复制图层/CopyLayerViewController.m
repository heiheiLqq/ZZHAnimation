//
//  VoiceViewController.m
//  ZZHAnimation
//
//  Created by zzh on 2017/1/23.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "CopyLayerViewController.h"

#import "VoiceView.h"

#include "IndicatorView.h"

#import "InvertedView.h"

@interface CopyLayerViewController ()

@end

@implementation CopyLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

    VoiceView * vocieView = [VoiceView voiceView];
    vocieView.frame = CGRectMake(10, 70, 200, 200);
    [self.view addSubview:vocieView];
    
    IndicatorView * indicatorView = [IndicatorView indicatorView];
    indicatorView.frame = CGRectMake(10, CGRectGetMaxY(vocieView.frame)+20,150 , 150);
    [self.view addSubview:indicatorView];
    
    
    InvertedView * invertedView = [InvertedView invertedView];
    
    invertedView.frame = CGRectMake(CGRectGetMaxX(indicatorView.frame)+10, CGRectGetMaxY(vocieView.frame)+20,150, 150);
    
    [self.view addSubview:invertedView];
    

    
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
