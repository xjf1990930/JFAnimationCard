//
//  JFCardAnimationView.m
//  testForCardAnimation
//
//  Created by 五维科技 on 15/12/30.
//  Copyright © 2015年 五维科技. All rights reserved.
//

#import "JFCardAnimationView.h"
#import "JFDefaultCardView.h"

@interface JFCardAnimationView ()<JFDefaultCardDelegate>

@property (strong, nonatomic) UIView*frontView;//当前第一个view

@property (nonatomic, strong) UIView*queryView;//队列中的view

@property (nonatomic, strong) NSMutableArray*showViews;//所有在视图中的view

@property (nonatomic, strong) NSMutableArray*gestures;//所有的pan手势

@property (nonatomic, assign) NSInteger currentCount;//当被推出的视图数量

@property (nonatomic, assign) NSInteger maxCount;//最大可被推出的视图量

@property (nonatomic, assign) NSInteger showCount;//视图中显示的视图数量

@property (nonatomic, assign) CGPoint tagetCenter;//当前第一个view的center

@property (nonatomic, assign) CGPoint queryViewCenter;//队列中view的center

@property (nonatomic, assign) BOOL canMoveView;//当前第一个view是否可以被拖动

@property (nonatomic, assign) BOOL canCycle;//是否循环滚动

@property (nonatomic, assign) BOOL ignoreGES;//是否忽视本次手势

@property (nonatomic, assign) CGPoint preferCenter;//本视图的中心点

@end

static CGFloat viewGaps = 15.0;

static CGFloat viewScale = 0.04;

@implementation JFCardAnimationView

-(id)initWithFrame:(CGRect)frame andShowCardCount:(NSInteger)showCount andMaxCardCount:(NSInteger)maxCount andDataSource:(id)dataSource
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.preferCenter = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        
        self.currentCount = 0;
        
        self.maxCount = maxCount;
        
        self.showCount = showCount;
        
        self.canCycle = YES;
        
        self.dataSource = dataSource;
        
        for (int i = 0; i<showCount+1; i++) {
            
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _preferCenter.x*2, _preferCenter.y*2)];
            
            view.center = CGPointMake(_preferCenter.x, _preferCenter.y + i*viewGaps);
            
            view.transform = CGAffineTransformMakeScale(1-i*viewScale, 1-i*viewScale);
            
            view.backgroundColor = [UIColor greenColor];
            
            view.layer.borderColor = [UIColor colorWithRed:223.0/255 green:224.0/255 blue:225.0/255 alpha:1].CGColor;
            
            view.layer.borderWidth = 1;
            
            view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            
            view.layer.shadowOpacity = 0.6;
            
            view.layer.shadowOffset = CGSizeMake(0, 1);
            
            UIPanGestureRecognizer*panGES = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];
            
            UITapGestureRecognizer*tapGES = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardViewTapped:)];
            
            [view addGestureRecognizer:tapGES];
            
            [view addGestureRecognizer:panGES];
            
            NSArray*subViews = nil;
            
            if ([self.dataSource respondsToSelector:@selector(cardViewSubViewsForCardViewAtIndex:)]) {
                
                subViews = [self.dataSource cardViewSubViewsForCardViewAtIndex:i];
                
            }
            
            
            if (subViews) {
                
                for (UIView*subView in [view subviews]) {
                    
                    [subView removeFromSuperview];
                    
                }
                
                for (UIView*subView in subViews) {
                    
                    [view addSubview:subView];
                    
                }
                
            }else{
                
                if (i<showCount) {
                    
                    for (JFDefaultCardView*defaultView in [self defaultCardViewSubViews]) {
                        
                        if ([self.dataSource respondsToSelector:@selector(cardViewDisplayDataForCardViewAtIndex:)]) {
                            
                            [defaultView setDisplayData:[self.dataSource cardViewDisplayDataForCardViewAtIndex:i]];
                            
                        }
                        
                        defaultView.tag = 1990;//设置一个tag值，方便找到它
                        
                        [view addSubview:defaultView];
                        
                    }
                    
                }else{
                    
                    for (JFDefaultCardView*defaultView in [self defaultCardViewSubViews]) {
                        
                        defaultView.tag = 1990;//设置一个tag值，方便找到它
                        
                        [view addSubview:defaultView];
                        
                    }
                    
                }
                
            }
            
            [self.gestures addObject:panGES];
            
            if (i<showCount) {
                
                [self.showViews addObject:view];
                
                [self addSubview:view];
                
                [self sendSubviewToBack:view];
                
            }else{
                
                self.queryView = view;
                
            }
            
        }
        
        self.frontView = self.showViews[0];
        
        self.tagetCenter = self.frontView.center;
        
    }
    
    return self;
    
}
- (void)panned:(UIPanGestureRecognizer *)sender {
    
    if (self.currentCount>=self.maxCount && !self.canCycle) {
        
        return;
        
    }
    
    CGPoint transition = [sender translationInView:self.frontView];
    
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            if (transition.x<0) {
                
                self.canMoveView = YES;
                
            }else if(transition.x>0){
                
                self.canMoveView = NO;
                
                if (self.currentCount) {
                    
                    //更新即将进入页面的上一张卡片的展示数据
                    JFDefaultCardView*defaultView = nil;
                    
                    for (UIView*subView in [self.queryView subviews]) {
                        
                        if (subView.tag == 1990) {
                            
                            defaultView = (JFDefaultCardView*)subView;
                            
                            break;
                            
                        }
                        
                    }
                    
                    if (defaultView) {
                        
                        if ([self.dataSource respondsToSelector:@selector(cardViewDisplayDataForCardViewAtIndex:)]) {
                            
                            [defaultView setDisplayData:[self.dataSource cardViewDisplayDataForCardViewAtIndex:(self.currentCount-1)%self.maxCount]];
                            
                        }
                        
                    }
                    
                    //设置卡片进入动画
                    [self addSubview:self.queryView];
                    
                    self.queryViewCenter = CGPointMake(_preferCenter.x-CGRectGetWidth(self.frame)/2-CGRectGetWidth(_queryView.frame)/2, _preferCenter.y);
                    
                    _queryView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    
                    self.queryView.center = self.queryViewCenter;
                    
                    __weak __typeof(self)weakSelf = self;
                    
                    for (NSInteger i = 0; i<self.showViews.count; i++) {
                        
                        UIView*view = self.showViews[i];
                        
                        CGPoint center = view.center;
                        
                        center.y += viewGaps;
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            view.center = center;
                            
                            view.transform = CGAffineTransformMakeScale(1.0-(i+1)*viewScale,1.0-(i+1)*viewScale);
                            
                            if (i == weakSelf.showViews.count-1) {
                                
                                view.alpha = 0;
                                
                            }
                            
                        }];
                        
                    }
                    
                }
                
            }else{
                
                self.canMoveView = NO;
                
                self.ignoreGES = YES;
                
                return;
                
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            if (self.ignoreGES) {
                
                return;
                
            }
            
            if (self.canMoveView) {
                
                CGPoint center = self.frontView.center;
                
                center.x = self.tagetCenter.x + transition.x;
                
                self.frontView.center = center;
                
            }else{
                
                if (self.currentCount) {
                    
                    CGPoint center = self.quryView.center;
                    
                    center.x = self.queryViewCenter.x + transition.x;
                    
                    self.queryView.center = center;
                    
                }
                
            }
            
        }
            
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            if (self.ignoreGES) {
                
                self.ignoreGES = NO;
                
                return;
                
            }
            
            if (self.canMoveView) {
                
                self.tagetCenter = self.frontView.center;
                
                if (self.tagetCenter.x<self.preferCenter.x-50.0) {
                    
                    CGPoint center = self.frontView.center;
                    
                    center.x = -CGRectGetWidth(self.frontView.frame)/2-CGRectGetWidth(self.frame)/2;
                    
                    __weak __typeof (self)weakSelf = self;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        weakSelf.frontView.center = center;
                        
                        for (NSInteger i = 1; i<self.showViews.count; i++) {
                            
                            UIView*view = self.showViews[i];
                            
                            if (view != weakSelf.frontView) {
                                
                                CGPoint center = view.center;
                                
                                center.y -= viewGaps;
                                
                                view.center = center;
                                
                                view.transform = CGAffineTransformMakeScale(1.0-(i-1)*viewScale,1.0-(i-1)*viewScale);
                                
                            }
                            
                        }
                        
                        
                    }completion:^(BOOL finished) {
                        
                        [weakSelf.frontView removeFromSuperview];
                        
                        [weakSelf.showViews removeObjectAtIndex:0];
                        
                        weakSelf.queryView.alpha = 0;
                        
                        [weakSelf.showViews addObject:weakSelf.quryView];
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            weakSelf.queryView.alpha = 1;
                            
                        }];
                        
                        
                        //更新即将进入页面的上一张卡片的展示数据
                        JFDefaultCardView*defaultView = nil;
                        
                        for (UIView*subView in [self.queryView subviews]) {
                            
                            if (subView.tag == 1990) {
                                
                                defaultView = (JFDefaultCardView*)subView;
                                
                                break;
                                
                            }
                            
                        }
                        
                        if (defaultView) {
                            
                            if ([self.dataSource respondsToSelector:@selector(cardViewDisplayDataForCardViewAtIndex:)]) {
                                
                                [defaultView setDisplayData:[self.dataSource cardViewDisplayDataForCardViewAtIndex:(self.currentCount+self.showCount)%self.maxCount]];
                                
                            }
                            
                        }
                        
                        //更换队列中的卡片视图
                        [weakSelf addSubview:weakSelf.quryView];
                        
                        [weakSelf sendSubviewToBack:weakSelf.quryView];
                        
                        weakSelf.queryView = weakSelf.frontView;
                        
                        weakSelf.frontView = weakSelf.showViews[0];
                        
                        weakSelf.tagetCenter = weakSelf.frontView.center;
                        
                        weakSelf.currentCount ++;
                        
                    }];
                    
                }else{
                    
                    CGPoint center = self.frontView.center;
                    
                    center.x = self.preferCenter.x;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        self.frontView.center = center;
                        
                    } completion:^(BOOL finished) {
                        
                        self.tagetCenter = self.frontView.center;
                        
                    }];
                    
                }
                
            }else{
                
                if (self.currentCount) {
                    
                    if (self.queryView.center.x>=self.preferCenter.x-CGRectGetWidth(self.queryView.frame)*3/4) {
                        
                        __weak __typeof(self)weakSelf = self;
                        
                        [UIView animateWithDuration:0.2 animations:^{
                            
                            weakSelf.queryView.center = weakSelf.preferCenter;
                            
                        } completion:^(BOOL finished) {
                            
                            [weakSelf.showViews insertObject:weakSelf.queryView atIndex:0];
                            
                            weakSelf.frontView = weakSelf.queryView;
                            
                            weakSelf.queryView = [weakSelf.showViews lastObject];
                            
                            [weakSelf.showViews removeObject:weakSelf.queryView];
                            
                            [weakSelf.queryView removeFromSuperview];
                            
                            weakSelf.queryView.alpha = 1;
                            
                            weakSelf.currentCount --;
                            
                        }];
                        
                    }else{
                        
                        __weak __typeof(self)weakSelf = self;
                        
                        for (NSInteger i = 0; i<self.showViews.count; i++) {
                            
                            UIView*view = self.showViews[i];
                            
                            CGPoint center = view.center;
                            
                            center.y -= viewGaps;
                            
                            [UIView animateWithDuration:0.3 animations:^{
                                
                                view.center = center;
                                
                                view.transform = CGAffineTransformMakeScale(1.0-i*viewScale,1.0-i*viewScale);
                                
                                if (i == weakSelf.showViews.count-1) {
                                    
                                    view.alpha = 1;
                                    
                                }
                                
                            }];
                            
                        }
                        
//                        CGPoint preferCenter = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            weakSelf.queryView.center = CGPointMake(_preferCenter.x-CGRectGetWidth(weakSelf.frame)/2-CGRectGetWidth(_queryView.frame)/2, _preferCenter.y);
                            
                        } completion:^(BOOL finished) {
                            
                            [weakSelf.queryView removeFromSuperview];
                            
                        }];
                        
                    }
                    
                }
                
            }
            
        }
            
            break;
            
        default:
            break;
    }
    
}
-(void)cardViewTapped:(UITapGestureRecognizer*)sender
{
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(cardViewClickCardAtIndex:)]) {
            
            [self.delegate cardViewClickCardAtIndex:self.currentCount%self.maxCount];
            
        }
        
    }
    
}
-(NSArray*)defaultCardViewSubViews
{
    
    JFDefaultCardView*defaultView = [[[NSBundle mainBundle] loadNibNamed:@"JFDefaultCardView" owner:nil options:nil] firstObject];
    
    defaultView.frame = CGRectMake(0, 0, self.preferCenter.x*2, self.preferCenter.y*2);
    
    defaultView.delegate = self;
    
    return @[defaultView];
    
}
#pragma mark ---- 默认卡片布局的代理
-(void)defaultCardViewSubViewClikedAtIndex:(NSInteger)index
{
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(cardViewClickCardAtIndex:)]) {
            
            NSIndexPath*indexPath = [NSIndexPath indexPathForRow:index inSection:self.currentCount%self.maxCount];
            
            [self.delegate cardViewSubViewClickCardAtIndex:indexPath];
            
        }
        
    }
    
}
#pragma mark ---- getter方法
-(NSMutableArray*)showViews
{
    
    if (!_showViews) {
        
        _showViews = [NSMutableArray new];
        
    }
    
    return _showViews;
    
}
-(UIView*)quryView
{
    
    if (_queryView) {
        
//        CGPoint preferCenter = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        
        if (self.canMoveView) {
            
            _queryView.center = CGPointMake(_preferCenter.x, _preferCenter.y + (self.showCount-1)*viewGaps);
            
            _queryView.transform = CGAffineTransformMakeScale(1-(self.showCount-1)*viewScale, 1-(self.showCount-1)*viewScale);
            
//            _queryView.alpha = 1;
            
        }else{
            
            //            _queryView.center = CGPointMake(preferCenter.x-CGRectGetWidth(self.view.frame)/2-CGRectGetWidth(_queryView.frame)/2, preferCenter.y);
            
            _queryView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }
        
    }
    
    return _queryView;
    
}
-(NSMutableArray*)gestures
{
    
    if (!_gestures) {
        
        _gestures = [NSMutableArray new];
        
    }
    
    return _gestures;
    
}

@end
