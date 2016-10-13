//
//  JFCardAnimationView.h
//  testForCardAnimation
//
//  Created by 五维科技 on 15/12/30.
//  Copyright © 2015年 五维科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFCardViewDataSource <NSObject>

/**
 设置某张卡片视图上的子视图（如果return空，则会加载默认的视图，如果return空数组，则仅加载卡片）
 **/
@optional
-(NSArray*)cardViewSubViewsForCardViewAtIndex:(NSInteger)index;

/**
 默认卡片视图上加载的数据源
 **/
@optional
-(id)cardViewDisplayDataForCardViewAtIndex:(NSInteger)index;

@end

@protocol JFCardViewDelegate <NSObject>

/**
 某张卡片被点击
 **/
@optional
-(void)cardViewClickCardAtIndex:(NSInteger)index;

/**
 某张卡片的某个子视图被点击
 **/
@optional
-(void)cardViewSubViewClickCardAtIndex:(NSIndexPath*)indexPath;

@end

@interface JFCardAnimationView : UIView

@property (nonatomic, weak)id<JFCardViewDataSource>dataSource;

@property (nonatomic, weak)id<JFCardViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame andShowCardCount:(NSInteger)showCount andMaxCardCount:(NSInteger)maxCount andDataSource:(id)dataSource;

@end
