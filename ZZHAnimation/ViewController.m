//
//  ViewController.m
//  Quartz 2D Demo
//
//  Created by zzh on 2017/1/20.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ViewController.h"
#import "CATransactionViewController.h"
#import "CABasicAnimationViewController.h"
#import "CAKeyframeAnimationViewController.h"
#import "CAAnimationGroupViewController.h"
#import "CAAnimationViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView * tableView;
@property (nonatomic,copy)NSArray * dataSource;





@end

@implementation ViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    
    
}
-(NSArray *)dataSource{
    
    if (!_dataSource) {
        
        _dataSource = @[@"隐式动画",@"CABasicAnimation",@"CAKeyframeAnimation",@"CAAnimationGroup",@"转场动画"];
    }
    return _dataSource;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        CATransactionViewController * transView = [[CATransactionViewController alloc] init];
        
        transView.title = @"隐式动画";
        
        [self.navigationController pushViewController:transView animated:YES];
        
    }else if (indexPath.row == 1){
    
        CABasicAnimationViewController * transView = [[CABasicAnimationViewController alloc] init];
        transView.title = @"CABasicAnimation";
        
        [self.navigationController pushViewController:transView animated:YES];
    
    }else if (indexPath.row == 2){
    
        
        CAKeyframeAnimationViewController * transView = [[CAKeyframeAnimationViewController alloc] init];
        transView.title = @"CAKeyframeAnimation";
        
        [self.navigationController pushViewController:transView animated:YES];
    
    }else if ( indexPath.row == 3){
    
        
        CAAnimationGroupViewController * transView = [[CAAnimationGroupViewController alloc] init];
        transView.title = @"CAAnimationGroup";
        
        [self.navigationController pushViewController:transView animated:YES];
    
    }else if ( indexPath.row == 4){
    
        CAAnimationViewController * transView = [[CAAnimationViewController alloc] init];
        transView.title = @"转场动画";
        
        [self.navigationController pushViewController:transView animated:YES];
    
    }
    
    
}




















@end
