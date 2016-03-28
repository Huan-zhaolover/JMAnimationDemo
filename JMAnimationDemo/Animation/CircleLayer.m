//
//  CircleLayer.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/14.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

typedef enum MovingPoint {
    MovingPointA,
    MovingPointB,
    MovingPointC,
    MovingPointD,
} MovingPoint;

static CGFloat outsideRectSize = 90;

@interface CircleLayer ()

@property (nonatomic, assign) CGRect outsideRect;
@property (nonatomic, assign) CGFloat lastProgress;

@end

@implementation CircleLayer {
    MovingPoint _movePoint;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithLayer:(CircleLayer *)layer {
    self = [super initWithLayer:layer];
    if (self) {
        _progress = layer.progress;
        _outsideRect = layer.outsideRect;
        _lastProgress = layer.lastProgress;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    //只要外接矩形在左侧，则改变B点，在右边，则改变D点。
    if (progress <= 0.5) {
        _movePoint = MovingPointB;
    } else {
        _movePoint = MovingPointD;
    }
    CGFloat originX = self.position.x - outsideRectSize/2 + (progress - 0.5)*(self.frame.size.width - outsideRectSize);
    CGFloat originY = self.position.y - outsideRectSize/2;
    self.outsideRect = CGRectMake(originX, originY, outsideRectSize, outsideRectSize);
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    //A-C1、B-C2... 的距离，当设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形
    CGFloat offset = _outsideRect.size.width / 3.6;
    //A.B.C.D实际需要移动的距离.系数为滑块偏离中点0.5的绝对值再乘以2.当滑到两端的时候，movedDistance为最大值：「外接矩形宽度的1/5」.
    CGFloat movedDistance = (_outsideRect.size.width / 6) * fabs(_progress - 0.5) * 2;
    //方便下方计算各点坐标，先算出外接矩形的中心点坐标
    CGPoint rectCenter = CGPointMake(_outsideRect.origin.x + _outsideRect.size.width/2, _outsideRect.origin.y + _outsideRect.size.height/2);
    CGPoint pointA = CGPointMake(rectCenter.x, _outsideRect.origin.y + movedDistance);
    CGPoint pointB = CGPointMake(_movePoint == MovingPointB ? rectCenter.x + _outsideRect.size.width/2 + movedDistance*2 : rectCenter.x + _outsideRect.size.width/2, rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x, rectCenter.y + _outsideRect.size.height/2 - movedDistance);
    CGPoint pointD = CGPointMake(_movePoint == MovingPointD ? _outsideRect.origin.x - movedDistance*2 : _outsideRect.origin.x, rectCenter.y);
    
    CGPoint C1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint C2 = CGPointMake(pointB.x, _movePoint == MovingPointB ? pointB.y - offset + movedDistance : pointB.y - offset);
    CGPoint C3 = CGPointMake(pointB.x, _movePoint == MovingPointB ? pointB.y + offset - movedDistance : pointB.y + offset);
    CGPoint C4 = CGPointMake(pointC.x + offset, pointC.y);
    CGPoint C5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint C6 = CGPointMake(pointD.x, _movePoint == MovingPointD ? pointD.y + offset - movedDistance : pointD.y + offset);
    CGPoint C7 = CGPointMake(pointD.x, _movePoint == MovingPointD ? pointD.y - offset + movedDistance : pointD.y - offset);
    CGPoint C8 = CGPointMake(pointA.x - offset, pointA.y);
    
    //外接虚线矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:_outsideRect];
    CGContextAddPath(ctx, rectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGFloat lengths[] = {5, 5};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    //画虚线，lengths是个数组，先跳过phase个点，再交替绘制和不绘制数组里的点，count是数组的大小
    CGContextStrokePath(ctx); //给线条填充颜色
    
    //圆的边界
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:C1 controlPoint2:C2];
    [ovalPath addCurveToPoint:pointC controlPoint1:C3 controlPoint2:C4];
    [ovalPath addCurveToPoint:pointD controlPoint1:C5 controlPoint2:C6];
    [ovalPath addCurveToPoint:pointA controlPoint1:C7 controlPoint2:C8];
    [ovalPath closePath];
    
    CGContextAddPath(ctx, ovalPath.CGPath); //CGPathRef
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [self colorFromRGB:0x99CCCC].CGColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);//同时给线条和线条包围的内部区域填充颜色
    
    CGContextSetLineDash(ctx, 0, NULL, 0);
    //恢复成画直线
    
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *points = @[[NSValue valueWithCGPoint:pointA],[NSValue valueWithCGPoint:pointB], [NSValue valueWithCGPoint:pointC], [NSValue valueWithCGPoint:pointD], [NSValue valueWithCGPoint:C1], [NSValue valueWithCGPoint:C2], [NSValue valueWithCGPoint:C3], [NSValue valueWithCGPoint:C4], [NSValue valueWithCGPoint:C5], [NSValue valueWithCGPoint:C6] ,[NSValue valueWithCGPoint:C7], [NSValue valueWithCGPoint:C8]];
    [self drawPoint:points withContext:ctx];
    
    //连接辅助线
    UIBezierPath *helperLine = [UIBezierPath bezierPath];
    [helperLine moveToPoint:pointA];
    [helperLine addLineToPoint:C1];
    [helperLine addLineToPoint:C2];
    [helperLine addLineToPoint:pointB];
    [helperLine addLineToPoint:C3];
    [helperLine addLineToPoint:C4];
    [helperLine addLineToPoint:pointC];
    [helperLine addLineToPoint:C5];
    [helperLine addLineToPoint:C6];
    [helperLine addLineToPoint:pointD];
    [helperLine addLineToPoint:C7];
    [helperLine addLineToPoint:C8];
    [helperLine closePath];
    
    CGContextAddPath(ctx, helperLine.CGPath);
    CGFloat lengths2[] = {2, 2};
    CGContextSetLineDash(ctx, 0, lengths2, 2);
    CGContextStrokePath(ctx);//给辅助线条填充颜色
}

- (void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx {
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2, point.y - 2, 4, 4));
    }
}

- (UIColor *)colorFromRGB:(NSInteger)RGBValue {
    return [UIColor colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 green:((float)((RGBValue & 0xFF00) >> 8))/255.0 blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0];
}

@end
