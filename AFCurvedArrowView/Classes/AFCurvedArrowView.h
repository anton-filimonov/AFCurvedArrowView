//
//  AFCurvedArrowView.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AFCurveType) {
    AFCurveTypeStraight,
    AFCurveTypeQuadratic,
    AFCurveTypeCubic
};

IB_DESIGNABLE
@interface AFCurvedArrowView : UIView

/**
 *  Type of the arrow line curve
 */
@property (assign, nonatomic) AFCurveType curveType;

/**
 *  Arrow head point in unit-based coordinates. Both coordinates could be only between 0 and 1
 */
@property (assign, nonatomic) IBInspectable CGPoint arrowHead;

/**
 *  Arrow tail point in unit-based coordinates. Both coordinates could be only between 0 and 1
 */
@property (assign, nonatomic) IBInspectable CGPoint arrowTail;

/**
 *  First control point for curve in unit-based coordinates (not limited to values between 0 and 1). Used only when \c curveType is of \c AFCurveTypeQuadratic or \c AFCurveTypeCubic
 */
@property (assign, nonatomic) IBInspectable CGPoint controlPoint1;

/**
 *  Second control point for curve in unit-based coordinates (not limited to values between 0 and 1). Used only when \c curveType is of \c AFCurveTypeCubic
 */
@property (assign, nonatomic) IBInspectable CGPoint controlPoint2;

/**
 *  Width of the line
 */
@property (assign, nonatomic) IBInspectable CGFloat lineWidth;

/**
 *  The line join parameter for drawing the arrow head (if no \c arrowHeadImage is set)
 */
@property (assign, nonatomic) CGLineJoin arrowHeadLineJoin;

/**
 *  The dash phase parameter for the line (useful if you set \c lineDashPattern)
 */
@property (assign, nonatomic) CGFloat lineDashPhase;

/**
 *  The dash pattern to use when drawing the arrow line (consists of numbers where each number shows the length of dash or gap)
 */
@property (copy, nonatomic, nullable) NSArray<NSNumber *> *lineDashPattern;

/**
 *  Arrow line color. (Also used for arrow head when \c arrowHeadImage is not set). Defaults to white
 */
@property (strong, nonatomic, null_resettable) IBInspectable UIColor *lineColor;

/**
 *  The image to use for arrow head. The arrow on image should be in position, in which it points up.
 */
@property (strong, nonatomic, nullable) IBInspectable UIImage *arrowHeadImage;

/**
 *  The anchor point in unit-based coordinates (both coordinates could be only between 0 and 1), 
 *  which means the point of \c arrowHeadImage placed in the \c arrowHead point. Default value is {0.5, 0.0}
 */
@property (assign, nonatomic) IBInspectable CGPoint arrowHeadImageAnchorPoint;

/**
 *  The width for arrow head (if no \c arrowHeadImage is set)
 */
@property (assign, nonatomic) IBInspectable CGFloat arrowHeadWidth;

/**
 *  The height for arrow head (if no \c arrowHeadImage is set)
 */
@property (assign, nonatomic) IBInspectable CGFloat arrowHeadHeight;

@end
