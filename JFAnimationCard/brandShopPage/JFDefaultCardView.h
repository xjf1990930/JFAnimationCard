//
//  JFDefaultCardVIew.h
//  testForCardAnimation
//
//  Created by 五维科技 on 15/12/30.
//  Copyright © 2015年 五维科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFDefaultCardDelegate <NSObject>

-(void)defaultCardViewSubViewClikedAtIndex:(NSInteger)index;

@end

@interface JFDefaultCardView : UIView
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageViewI;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageViewII;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageViewIII;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabelI;
@property (weak, nonatomic) IBOutlet UILabel *priceLabelII;
@property (weak, nonatomic) IBOutlet UILabel *priceLabelIII;

@property (nonatomic, weak) id<JFDefaultCardDelegate>delegate;

-(void)setDisplayData:(id)data;

@end
