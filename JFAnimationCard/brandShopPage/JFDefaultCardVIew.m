//
//  JFDefaultCardVIew.m
//  testForCardAnimation
//
//  Created by 五维科技 on 15/12/30.
//  Copyright © 2015年 五维科技. All rights reserved.
//

#import "JFDefaultCardView.h"

@implementation JFDefaultCardView

-(void)awakeFromNib
{
    
    self.collectionButton.layer.cornerRadius = 5.0;
    
    self.collectionButton.layer.borderColor = [UIColor orangeColor].CGColor;
    
    self.collectionButton.layer.borderWidth = 1.0;
    
    self.collectionButton.layer.masksToBounds = YES;
    
    self.priceLabelI.backgroundColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:0.8];
    
    self.priceLabelII.backgroundColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:0.8];
    
    self.priceLabelIII.backgroundColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:0.8];
    
}
- (IBAction)buttonClicked:(UIButton *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(defaultCardViewSubViewClikedAtIndex:)]) {
            
            [self.delegate defaultCardViewSubViewClikedAtIndex:sender.tag];
            
        }
        
    }
    
}
- (IBAction)imageViewClicked:(UITapGestureRecognizer *)sender {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(defaultCardViewSubViewClikedAtIndex:)]) {
            
            [self.delegate defaultCardViewSubViewClikedAtIndex:sender.view.tag];
            
        }
        
    }
    
}
-(void)setDisplayData:(id)data
{
    
    //这里写设置的代码
    
}
@end
