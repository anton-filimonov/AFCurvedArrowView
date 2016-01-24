//
//  ViewController.m
//  AFCurvedArrowViewDemo
//
//  Created by Anton Filimonov on 26.12.15.
//  Copyright © 2015 Anton Filimonov. All rights reserved.
//

#import "ViewController.h"
#import <AFCurvedArrowView.h>

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *curveTypeSelectionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tweakingPointSelectionControl;
@property (weak, nonatomic) IBOutlet AFCurvedArrowView *arrowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    self.tweakingPointSelectionControl.apportionsSegmentWidthsByContent = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    pan.maximumNumberOfTouches = 1;
    pan.minimumNumberOfTouches = 1;
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    self.arrowView.lineDashPattern = @[@(10), @(5)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Handlers
- (IBAction)lineTypeChanged:(UISegmentedControl *)sender {
    NSUInteger targetNumberOfSegmentsInTweakingPointSelector = 2;
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.arrowView.curveType = AFCurveTypeStraight;
            break;
            
        case 1:
            self.arrowView.curveType = AFCurveTypeQuadratic;
            targetNumberOfSegmentsInTweakingPointSelector = 3;
            break;
            
        case 2:
            self.arrowView.curveType = AFCurveTypeCubic;
            targetNumberOfSegmentsInTweakingPointSelector = 4;
            break;
            
        default:
            break;
    }
    
    while (self.tweakingPointSelectionControl.numberOfSegments > targetNumberOfSegmentsInTweakingPointSelector) {
        [self.tweakingPointSelectionControl removeSegmentAtIndex:self.tweakingPointSelectionControl.numberOfSegments - 2 animated:NO];
    }
    
    while (self.tweakingPointSelectionControl.numberOfSegments < targetNumberOfSegmentsInTweakingPointSelector) {
        [self.tweakingPointSelectionControl insertSegmentWithTitle:self.tweakingPointSelectionControl.numberOfSegments == 2 ? @"ControlPoint1" : @"ControlPoint2"
                                                           atIndex:self.tweakingPointSelectionControl.numberOfSegments - 1
                                                          animated:NO];
    }
}

- (IBAction)arrowTypeChanged:(UISegmentedControl *)sender {
    self.arrowView.arrowHeadImage = sender.selectedSegmentIndex == 1 ? [UIImage imageNamed:@"ArrowHead"] : nil;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint touchPosition = [panRecognizer locationInView:self.arrowView];
    CGPoint normalizedPosition = CGPointMake(touchPosition.x / CGRectGetWidth(self.arrowView.frame), touchPosition.y / CGRectGetHeight(self.arrowView.frame));
    
    NSUInteger pointSelectorActiveIndex = self.tweakingPointSelectionControl.selectedSegmentIndex;
    if (pointSelectorActiveIndex == 0) {
        self.arrowView.arrowTail = normalizedPosition;
    } else if (pointSelectorActiveIndex == self.tweakingPointSelectionControl.numberOfSegments - 1) {
        self.arrowView.arrowHead = normalizedPosition;
    } else if (pointSelectorActiveIndex == 1) {
        self.arrowView.controlPoint1 = normalizedPosition;
    } else {
        self.arrowView.controlPoint2 = normalizedPosition;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isKindOfClass:[UIControl class]];
}

@end
