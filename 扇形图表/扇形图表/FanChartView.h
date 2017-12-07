//
//  FanChartView.h
//  ZXLGame
//
//  Created by Apple on 2017/12/6.
//  Copyright © 2017年 zxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FanChartView : UIView

/** 开始角度 */
@property (nonatomic, assign) double startAngle;
/** 顺序比例 按比例计算得出角度 */
@property (nonatomic, copy) NSArray * angles;

@end

@interface FanShapeLayer : CAShapeLayer


/** 起始弧度 **/
@property (nonatomic,assign) CGFloat startAngle;

/** 结束弧度 **/
@property (nonatomic,assign) CGFloat endAngle;

/** 圆饼半径 **/
@property (nonatomic,assign) CGFloat radius;

/** 圆饼放大时的半径 默认半径的1.2倍 **/
@property (nonatomic,assign) CGFloat enlargeRadius;

/** 是否点击 **/
@property (nonatomic,assign) BOOL isSelected;

/** 圆饼layer的圆心 **/
@property (nonatomic,assign) CGPoint centerPoint;

/** 绘制路径 **/
- (void)drawPath;

@end
