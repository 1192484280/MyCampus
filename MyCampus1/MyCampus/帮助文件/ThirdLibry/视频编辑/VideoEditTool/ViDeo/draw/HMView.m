//
//  HMView.m
//  小画板


#import "HMView.h"
#import "HMBezierPath.h"

@interface HMView ()
@property (nonatomic,strong)NSMutableArray * path;

@end

@implementation HMView
//懒加载
-(NSMutableArray *)path
{
    if (!_path) {
        _path = [NSMutableArray array];

    }
    return _path;
}

-(void)drawRect:(CGRect)rect
{
    //所有的路劲都渲染一次
    for (int i = 0; i < self.path.count; i++) {
        HMBezierPath * path = self.path[i];
        
#warning 这句话很重要 不要用self.lineColor 是每一个路径设置 如果没有这句话 不会显示颜色
        [path.lineColor set];
        
        // 设置连接出的样式
        [path setLineJoinStyle:kCGLineJoinRound];
        
        // 设置头尾的样式
        [path setLineCapStyle:kCGLineCapRound];
        
        [path stroke];
    }

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    // 获取触摸对象
    UITouch* t = touches.anyObject;
    
    // 获取当前手指的位置
    CGPoint p = [t locationInView:t.view];
    
    // 创建路径
    HMBezierPath* path = [[HMBezierPath alloc] init];
    
    // 设置起点
    [path moveToPoint:p];
    
    // 设置线宽
//    [path setLineWidth:self.lineWidth];
    
    //使用block来传值
    [path setLineWidth:self.lineWidth];

    
    // 设置颜色
    [path setLineColor:self.lineColor];
    
    // 把每一条创建的路径 添加到数组中 方便管理
    [self.path addObject:path];

    
    
}



-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //增加一个起点
    UITouch * touch = touches.anyObject;
    
    CGPoint p = [touch locationInView:touch.view];
    
    //始终是给数组中的最后的路径添加线
    [self.path.lastObject addLineToPoint:p];
    
    
#warning setNeedsDisplay一定要记得重绘
    [self setNeedsDisplay];
    
}

-(void)clear
{
    [self.path removeAllObjects];
    [self setNeedsDisplay];
}
-(void)back{
    [self.path removeLastObject];
    [self setNeedsDisplay];
}
-(void)erase
{
    self.lineColor =  [UIColor clearColor];
    [self setNeedsDisplay];
}
-(void)save{
  

}
@end
