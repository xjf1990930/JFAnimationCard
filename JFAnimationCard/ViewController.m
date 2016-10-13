//
//  ViewController.m
//  JFAnimationCard
//
//  Created by 五维科技 on 16/7/6.
//  Copyright © 2016年 五维科技. All rights reserved.
//

#import "ViewController.h"
#import "JFCardAnimationView.h"

@interface ViewController ()<JFCardViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    JFCardAnimationView*cardView = [[JFCardAnimationView alloc] initWithFrame:CGRectMake(15, 100, 320, 290) andShowCardCount:5 andMaxCardCount:100 andDataSource:self];
    
    [self.view addSubview:cardView];

}
#pragma mark ---- 协议代理实现
//-(id)cardViewDisplayDataForCardViewAtIndex:(NSInteger)index
//{
//    
//    return nil;
//    
//}
-(NSArray*)cardViewSubViewsForCardViewAtIndex:(NSInteger)index
{
    
    return nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
