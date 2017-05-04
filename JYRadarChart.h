//
//  JYRadarChart.h
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYRadarChart : UIView

@property (nonatomic, assign) CGFloat r;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) CGFloat pointsDiameter;
@property (nonatomic, assign) CGFloat pointsStrokeSize;
@property (nonatomic, assign) CGFloat pointsColorOpacity;
@property (nonatomic, assign) BOOL drawStrokePoints;
@property (nonatomic, assign) BOOL fillArea;
@property (nonatomic, assign) BOOL showLegend;
@property (nonatomic, assign) BOOL showAxes;
@property (nonatomic, assign) BOOL showStepText;
@property (nonatomic, assign) CGFloat colorOpacity;
@property (nonatomic, strong) UIColor *backgroundLineColorRadial;
@property (nonatomic, strong) NSArray *dataSeries;
@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, assign) NSUInteger steps;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, strong) UIColor *backgroundFillColor;

@property (nonatomic, strong) NSMutableArray *pointsColors;

@property (nonatomic, assign) BOOL  clockwise; //direction of data

- (void)setTitles:(NSArray *)titles;
- (void)setColors:(NSArray *)colors;
- (void)setPointsColors:(NSMutableArray *)pointsColors;

@end
