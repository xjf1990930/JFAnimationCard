# JFAnimationCard

一个简单的卡片堆叠视图

**
 设置某张卡片视图上的子视图（如果return空，则会加载默认的视图，如果return空数组，则仅加载卡片）
 **/
@optional
-(NSArray*)cardViewSubViewsForCardViewAtIndex:(NSInteger)index;

/**
 默认卡片视图上加载的数据源
 **/
@optional
-(id)cardViewDisplayDataForCardViewAtIndex:(NSInteger)index;

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
