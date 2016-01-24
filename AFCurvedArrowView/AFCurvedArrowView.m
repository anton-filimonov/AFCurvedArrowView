//
//  AFCurvedArrowView.m
//
//  Created by Anton Filimonov on 20.12.15.
//  Copyright © 2015 Anton Filimonov.
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "AFCurvedArrowView.h"

@interface AFCurvedArrowView ()

@property (strong, nonatomic) UIImageView *arrowHeadView;
@property (strong, nonatomic) CAShapeLayer *arrowHeadLayer;

@end

@implementation AFCurvedArrowView {
    CGFloat _arrowHeadHeight, _arrowHeadWidth;
    AFCurveType _curveType;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

+ (CGFloat)angleForLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat angle = M_PI_2;
    if (endPoint.x - startPoint.x == 0.0) {
        if (endPoint.y < startPoint.y) {
            angle = -M_PI_2;
        }
    } else {
        angle = atan((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x));
    }
    
    if (endPoint.x < startPoint.x) {
        angle = angle + M_PI;
    }
    
    //actual arrow is 90 degrees turned, so we need to adjust the result
    return angle + M_PI_2;
}

+ (CGPoint)pointAtPerCent:(CGFloat)percent forLineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGFloat x = startPoint.x + percent * (endPoint.x - startPoint.x);
    CGFloat y = startPoint.y + percent * (endPoint.y - startPoint.y);
    
    return CGPointMake(x, y);
}

+ (CGPoint)pointAtPercent:(CGFloat)percent forBezierCurveWithPoints:(NSArray<NSValue *> *)points {
    NSMutableArray *pointsMutable = [[NSMutableArray alloc] initWithArray:points];
    while (pointsMutable.count > 1) {
        for (int i = 0; i < pointsMutable.count - 1; i++)  {
            [pointsMutable replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:[self pointAtPerCent:percent forLineWithStartPoint:[pointsMutable[i] CGPointValue] endPoint:[pointsMutable[i + 1] CGPointValue]]]];
        }
        [pointsMutable removeObjectAtIndex:pointsMutable.count - 1];
    }
    return [[pointsMutable firstObject] CGPointValue];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self postInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self postInit];
    }
    return self;
}

- (void)postInit {
    [(CAShapeLayer *)self.layer setFillColor:[UIColor clearColor].CGColor];
    self.arrowHeadLayer = [CAShapeLayer new];
    self.arrowHeadLayer.fillColor = [UIColor clearColor].CGColor;
    self.arrowHeadLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.arrowHeadLayer];
    
    self.arrowHeadView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.arrowHeadView.layer.anchorPoint = CGPointMake(0.5, 0.0);
    [self addSubview:self.arrowHeadView];
    self.arrowHeadView.hidden = YES;
    _lineWidth = 1.0;
    _arrowHeadLineJoin = kCGLineJoinMiter;
    
    self.lineColor = [UIColor whiteColor];
}

#pragma mark - Custom Accessors
- (void)setCurveType:(AFCurveType)curveType {
    if (_curveType != curveType) {
        _curveType = curveType;
        [self.layer setNeedsLayout];
    }
}

- (void)setArrowHead:(CGPoint)arrowHead {
    arrowHead = [self validatedPoint:arrowHead];
    if (!CGPointEqualToPoint(arrowHead, _arrowHead)) {
        _arrowHead = arrowHead;
        [self.layer setNeedsLayout];
    }
}

- (void)setArrowTail:(CGPoint)arrowTail {
    arrowTail = [self validatedPoint:arrowTail];
    if (!CGPointEqualToPoint(arrowTail, _arrowTail)) {
        _arrowTail = arrowTail;
        [self.layer setNeedsLayout];
    }
}

- (void)setControlPoint1:(CGPoint)controlPoint1 {
    if (!CGPointEqualToPoint(controlPoint1, _controlPoint1)) {
        _controlPoint1 = controlPoint1;
        if (self.curveType != AFCurveTypeStraight) {
            [self.layer setNeedsLayout];
        }
    }
}

- (void)setControlPoint2:(CGPoint)controlPoint2 {
    if (!CGPointEqualToPoint(controlPoint2, _controlPoint2)) {
        _controlPoint2 = controlPoint2;
        if (self.curveType == AFCurveTypeCubic) {
            [self.layer setNeedsLayout];
        }
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        [(CAShapeLayer *)self.layer setLineWidth:lineWidth];
        self.arrowHeadLayer.lineWidth = lineWidth;
    }
}

- (void)setArrowHeadLineJoin:(CGLineJoin)arrowHeadLineJoin {
    if (_arrowHeadLineJoin != arrowHeadLineJoin) {
        _arrowHeadLineJoin = arrowHeadLineJoin;
        
        NSString *layerLineJoinValue = nil;
        switch (arrowHeadLineJoin) {
            case kCGLineJoinBevel:
                layerLineJoinValue = kCALineJoinBevel;
                break;
                
            case kCGLineJoinMiter:
                layerLineJoinValue = kCALineJoinMiter;
                break;
                
            case kCGLineJoinRound:
                layerLineJoinValue = kCALineJoinRound;
                break;
                
            default:
                break;
        }
        
        self.arrowHeadLayer.lineJoin = layerLineJoinValue;
    }
}

- (void)setLineDashPhase:(CGFloat)lineDashPhase {
    [(CAShapeLayer *)self.layer setLineDashPhase:lineDashPhase];
}

- (CGFloat)lineDashPhase {
    return [(CAShapeLayer *)self.layer lineDashPhase];
}

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern {
    [(CAShapeLayer *)self.layer setLineDashPattern:lineDashPattern];
}

- (NSArray<NSNumber *> *)lineDashPattern {
    return [(CAShapeLayer *)self.layer lineDashPattern];
}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor == nil) {
        lineColor = [UIColor blackColor];
    }
    [(CAShapeLayer *)self.layer setStrokeColor:lineColor.CGColor];
    self.arrowHeadLayer.strokeColor = lineColor.CGColor;
}

- (UIColor *)lineColor {
    return [UIColor colorWithCGColor:[(CAShapeLayer *)self.layer strokeColor]];
}

- (void)setArrowHeadImage:(UIImage *)arrowHeadImage {
    //take into account only addresses, because mostly we need to know when it changes from nil or to nil
    if (_arrowHeadImage != arrowHeadImage) {
        _arrowHeadImage = arrowHeadImage;
        if (arrowHeadImage == nil) {
            self.arrowHeadView.hidden = YES;
            self.arrowHeadLayer.hidden = NO;
        } else {
            self.arrowHeadView.hidden = NO;
            self.arrowHeadLayer.hidden = YES;
            CGSize oldImageSize = self.arrowHeadView.image.size;
            self.arrowHeadView.image = arrowHeadImage;
            if (!CGSizeEqualToSize(oldImageSize, arrowHeadImage.size)) {
                CGPoint anchorPoint = self.arrowHeadView.layer.anchorPoint;
                self.arrowHeadView.layer.anchorPoint = CGPointZero;
                self.arrowHeadView.transform = CGAffineTransformIdentity;
                self.arrowHeadView.frame = (CGRect){CGPointZero, arrowHeadImage.size};
                self.arrowHeadView.layer.anchorPoint = anchorPoint;
            }
        }
        [self.layer setNeedsLayout];
    }
}

- (void)setArrowHeadImageAnchorPoint:(CGPoint)arrowHeadImageAnchorPoint {
    self.arrowHeadView.layer.anchorPoint = [self validatedPoint:arrowHeadImageAnchorPoint];
}

- (CGPoint)arrowHeadImageAnchorPoint {
    return self.arrowHeadView.layer.anchorPoint;
}

- (void)setArrowHeadHeight:(CGFloat)arrowHeadHeight {
    if (_arrowHeadHeight != arrowHeadHeight) {
        _arrowHeadHeight = arrowHeadHeight;
        if (!self.arrowHeadImage) {
            [self.layer setNeedsLayout];
        }
    }
}

- (CGFloat)arrowHeight {
    if (self.arrowHeadImage) {
        return self.arrowHeadImage.size.height;
    } else {
        return _arrowHeadHeight;
    }
}

- (void)setArrowHeadWidth:(CGFloat)arrowHeadWidth {
    if (_arrowHeadWidth != arrowHeadWidth) {
        _arrowHeadWidth = arrowHeadWidth;
        if (!self.arrowHeadImage) {
            [self.layer setNeedsLayout];
        }
    }
}

- (CGFloat)arrowWidth {
    if (self.arrowHeadImage) {
        return self.arrowHeadImage.size.width;
    } else {
        return _arrowHeadWidth;
    }
}

#pragma mark - Layout
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        [self updatePaths];
    }
}

#pragma mark - Private
- (CGPoint)validatedPoint:(CGPoint)aPoint {
    CGPoint result;
    result.x = MAX(MIN(aPoint.x, 1.0), 0.0);
    result.y = MAX(MIN(aPoint.y, 1.0), 0.0);
    
    return result;
}

- (CGPoint)restoredPoint:(CGPoint)normalizedPoint {
    return CGPointMake(normalizedPoint.x * CGRectGetWidth(self.layer.bounds), normalizedPoint.y * CGRectGetHeight(self.layer.bounds));
}

- (UIBezierPath *)arrowHeadPath {
    //we need to draw arrow up with its frame origin at {0.0,0.0} to make its positioning same as for image
    UIBezierPath *result = [[UIBezierPath alloc] init];
    [result setLineWidth:self.lineWidth];
    [result setLineJoinStyle:self.arrowHeadLineJoin];
    [result moveToPoint:CGPointMake(-_arrowHeadWidth / 2.0, _arrowHeadHeight)];
    [result addLineToPoint:CGPointMake(0.0, 0.0)];
    [result addLineToPoint:CGPointMake(_arrowHeadWidth / 2.0, _arrowHeadHeight)];
    
    return result;
}

- (UIBezierPath *)arrowLinePath {
    CGPoint startPoint = [self restoredPoint:self.arrowTail];
    CGPoint endPoint = [self restoredPoint:self.arrowHead];
    CGPoint controlPoint1 = [self restoredPoint:self.controlPoint1];
    CGPoint controlPoint2 = [self restoredPoint:self.controlPoint2];
    
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    [linePath setLineWidth:self.lineWidth];
    [linePath moveToPoint:startPoint];
    
    switch (self.curveType) {
        case AFCurveTypeStraight:
            [linePath addLineToPoint:endPoint];
            break;
            
        case AFCurveTypeQuadratic: {
            [linePath addQuadCurveToPoint:endPoint controlPoint:controlPoint1];
        }
            break;
            
        case AFCurveTypeCubic: {
            [linePath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        }
            break;
            
        default:
            break;
    }
    
    return linePath;
}

- (CGAffineTransform)currentArrowTransform {
    CGPoint startPoint = [self restoredPoint:self.arrowTail];
    CGPoint endPoint = [self restoredPoint:self.arrowHead];
    CGPoint controlPoint1 = [self restoredPoint:self.controlPoint1];
    CGPoint controlPoint2 = [self restoredPoint:self.controlPoint2];
    
    CGFloat arrowAngle = 0.0;
    if (self.curveType == AFCurveTypeStraight) {
        arrowAngle = [AFCurvedArrowView angleForLineWithStartPoint:startPoint endPoint:endPoint];
    } else {
        CGPoint lastControlPoint = self.curveType == AFCurveTypeQuadratic ? controlPoint1 : controlPoint2;
        CGFloat tangentAngle = [AFCurvedArrowView angleForLineWithStartPoint:lastControlPoint endPoint:endPoint];
        
        CGFloat deltaX = fabs(endPoint.x - lastControlPoint.x);
        CGFloat deltaY = fabs(endPoint.y - lastControlPoint.y);
        CGFloat minDelta = MAX(deltaX, deltaY);
        if (minDelta != 0.0) {
            CGFloat meaningPercent = 1 - ((self.arrowHeight / 2.0) / minDelta);
            
            NSMutableArray *linePoints = [@[[NSValue valueWithCGPoint:startPoint], [NSValue valueWithCGPoint:controlPoint1], [NSValue valueWithCGPoint:endPoint]] mutableCopy];
            if (self.curveType == AFCurveTypeCubic) {
                [linePoints insertObject:[NSValue valueWithCGPoint:controlPoint2] atIndex:2];
            }
            CGPoint intermediatePoint = [AFCurvedArrowView pointAtPercent:meaningPercent
                                                 forBezierCurveWithPoints:linePoints];
            CGFloat intermediateAngle = [AFCurvedArrowView angleForLineWithStartPoint:intermediatePoint endPoint:endPoint];
            if (fabs(intermediateAngle - tangentAngle) > M_PI) {
                //angles could be almost equal but with opposite signs, so that we could get wrong average value
                //that's why we need to adjust the result here
                intermediateAngle += 2 * M_PI;
            }
            arrowAngle = (intermediateAngle + tangentAngle) / 2.0;
        } else {
            arrowAngle = tangentAngle;
        }
    }
    
    CGAffineTransform result = CGAffineTransformMakeTranslation(endPoint.x, endPoint.y);
    result = CGAffineTransformRotate(result, arrowAngle);
    
    return result;
}

- (void)updatePaths {
    [(CAShapeLayer *)self.layer setPath:[self arrowLinePath].CGPath];
    
    CGAffineTransform t = [self currentArrowTransform];
    
    if (self.arrowHeadImage) {
        self.arrowHeadView.transform = t;
    } else {
        UIBezierPath *arrowPath = [self arrowHeadPath];
        [arrowPath applyTransform:t];
        self.arrowHeadLayer.path = arrowPath.CGPath;
    }
    
}

#if TARGET_INTERFACE_BUILDER
- (AFCurveType)curveType {
    return AFCurveTypeCubic;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    [[self arrowLinePath] stroke];
    
    CGAffineTransform t = [self currentArrowTransform];
    
    if (!self.arrowHeadImage) {
        UIBezierPath *arrowPath = [self arrowHeadPath];
        [arrowPath applyTransform:t];
        [arrowPath stroke];
    }
}
#endif

@end
