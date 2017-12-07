//
//  FanChartView.m
//  ZXLGame
//
//  Created by Apple on 2017/12/6.
//  Copyright © 2017年 zxl. All rights reserved.
//

#import "FanChartView.h"

@interface FanChartView()

/** 半径 */
@property (nonatomic, assign) CGFloat radius;
/** 中心点 */
@property (nonatomic, assign) CGPoint chartPoint;
/** 创建数组-存放各种图形 */
@property (nonatomic, strong) NSMutableArray * fansArray;

@end

#define randomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@implementation FanChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 一半的0.8
        self.radius = frame.size.width * 0.5 * 0.8;
        self.chartPoint = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    // 绘制图形
    [self drawShapes];
}



- (void)drawShapes{
    // 每次绘制都清空数组
    self.fansArray = [NSMutableArray array];
    
    int max = 0;
    for (NSNumber * obj in self.angles) {
        max += [obj intValue];
    }
    
    CGFloat startAngle = self.startAngle;// 起点 0 代表x轴正方向
    
    for (int i = 0; i < self.angles.count; i ++) {
        NSNumber * obj = [self.angles objectAtIndex:i];
        
        CGFloat rate = [obj intValue];
        CGFloat angle = rate / max * M_PI * 2.0;
        
        // 计算绘制角度-终点 绘制的角度 绘制的方向是逆时针的所以是减
        CGFloat endAngle = startAngle - angle;
        
        // 设置颜色
        UIColor * color = randomColor;
        
        // 创建FanShapeLayer
        FanShapeLayer * layer = [[FanShapeLayer alloc]init];
        layer.fillColor = color.CGColor;
        layer.name = [NSString stringWithFormat:@"图层 = %d",i];
        layer.startAngle = startAngle;
        layer.endAngle = endAngle;
        layer.radius = self.radius;
        layer.centerPoint = self.chartPoint;
        // 绘制路径(先设置参数)
        [layer drawPath];
        [self.layer addSublayer:layer];
        [self.fansArray addObject:layer];
        
        // 计算下一次绘制起点
        startAngle -= angle;
    }
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取点击的中心点
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 获取点击区域 是否包含的CAShapeLayer
    FanShapeLayer * layer = [self touchLayer:point];
    if (layer) {
        NSLog(@"%@", layer.name);
        // 设置选中的为未选中
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelected = YES"];
        NSArray * selectArray = [self.fansArray filteredArrayUsingPredicate:predicate];
        [selectArray makeObjectsPerformSelector:@selector(setIsSelected:) withObject:@NO];
        if ([selectArray containsObject:layer]) {
            return ;
        }
        // 添加动画
        layer.isSelected = YES;
    }
}

- (FanShapeLayer *)touchLayer:(CGPoint)point{
    
    // 获取点击的区域layer
    for (FanShapeLayer * layer in self.fansArray) {
        // 获取inPoint，在layer中的坐标
        CGPoint inPoint = [layer convertPoint:point fromLayer:self.layer];
        
        if (CGPathContainsPoint(layer.path, 0, inPoint, YES)) {
            return layer;
        }
    }
    return nil;
}



@end

@interface FanShapeLayer ()<CAAnimationDelegate>

/** 重新定义path **/
@property(nullable) CGPathRef endPath;

@end

@implementation FanShapeLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    _enlargeRadius = _radius * 1.2;
}



- (void)drawPath{
    CGFloat radius = _isSelected ? self.enlargeRadius : self.radius;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformMakeTranslation(1, 1);
    CGPathMoveToPoint(path, &transform, self.centerPoint.x, self.centerPoint.y);
    CGPathAddArc(path, &transform, self.centerPoint.x, self.centerPoint.y, radius, self.startAngle, self.endAngle, YES);
    CGPathCloseSubpath(path);
    
    
    
    if (self.endPath == nil) {
        self.path = path;
    }
    self.endPath = path;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    // 绘制路径
    [self drawPath];
    
    if (_isSelected == NO) {
        self.path = self.endPath;
        [self removeAllAnimations];
    }else{
        // 添加动画
        CABasicAnimation *animation = [CABasicAnimation animation];
        // keyPath内容是对象的哪个属性需要动画
        animation.keyPath = @"path";
        // 设置代理
        animation.delegate = self;
        // 所改变属性的结束时的值
        animation.toValue = (__bridge id _Nullable)(self.endPath);
        // 动画时长
        animation.duration = 0.25;
        // 结束后不移除
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        // 添加动画
        [self addAnimation:animation forKey:nil];
    }
}


#pragma mark CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        // 使放大的时候可以点击边缘
        self.path = self.endPath;
    }
    
    
}

@end
