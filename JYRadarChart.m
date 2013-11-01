//
//  JYPolygon.m
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "JYRadarChart.h"
#import "JYLegendView.h"

#define PADDING 13
#define LEGEND_PADDING 3

@interface JYRadarChart ()

@property (nonatomic, assign) NSUInteger numOfV;
@property (nonatomic, strong) JYLegendView *legendView;

@end

@implementation JYRadarChart

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		_maxValue = 100.0;
		_centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		_r = MIN(self.frame.size.width / 2 - PADDING, self.frame.size.height / 2 - PADDING);
		_steps = 0;
		_drawPoints = NO;
		_showLegend = NO;
		_showStepText = NO;
		_minValue = 0;
		_backgroundLineColor = [UIColor darkGrayColor];
		self.legendView = [[JYLegendView alloc] initWithFrame:CGRectMake(frame.size.width - 60, 10, 50, 70)];
		self.legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		self.legendView.backgroundColor = [UIColor clearColor];
		self.legendView.colors = [NSMutableArray array];
		self.attributes = @[@"you", @"should", @"set", @"these", @"data", @"titles,",
		                    @"this", @"is", @"just", @"a", @"placeholder"];
	}
	return self;
}

- (void)setShowLegend:(BOOL)showLegend {
	_showLegend = showLegend;
	if (_showLegend) {
		[self addSubview:self.legendView];
	}
	else {
		for (UIView *subView in self.subviews) {
			if ([subView isKindOfClass:[JYLegendView class]]) {
				[subView removeFromSuperview];
			}
		}
	}
}

- (void)setTitles:(NSArray *)titles {
	self.legendView.titles = titles;
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[self.legendView sizeToFit];
	[self.legendView setNeedsDisplay];
}

- (void)setDataSeries:(NSArray *)dataSeries {
	_dataSeries = dataSeries;
	_numOfV = [_dataSeries[0] count] - 1;
	for (int i = 0; i < _dataSeries.count; i++) {
		UIColor *color = [UIColor colorWithHue:(i * 5 % 17) / 17.0
		                            saturation:1
		                            brightness:1
		                                 alpha:1];
		self.legendView.colors[i] = color;
	}
}

- (void)layoutSubviews {
	[self.legendView sizeToFit];
	CGRect r = self.legendView.frame;
	r.origin.x = self.frame.size.width - self.legendView.frame.size.width - LEGEND_PADDING;
	r.origin.y = LEGEND_PADDING;
	self.legendView.frame = r;
	[self bringSubviewToFront:self.legendView];
}

- (void)drawRect:(CGRect)rect {
	NSArray *colors = [self.legendView.colors copy];
	CGFloat radPerV = M_PI * 2 / _numOfV;
	CGContextRef context = UIGraphicsGetCurrentContext();

	//draw attribute text
	UIFont *scaleFont = [UIFont systemFontOfSize:10];
	CGFloat height = [scaleFont lineHeight];
	for (int i = 0; i < _numOfV; i++) {
		NSString *title = _attributes[i];
		CGPoint pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
		NSInteger width = [title sizeWithFont:scaleFont].width;
		CGFloat padding = 2.0;
		CGFloat xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
		CGFloat yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
		CGPoint legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset);
		[title drawInRect:CGRectMake(legendCenter.x - width / 2.0,
		                             legendCenter.y - height / 2.0,
		                             width, height)
		         withFont:scaleFont
		    lineBreakMode:NSLineBreakByClipping
		        alignment:NSTextAlignmentCenter];
	}


	//draw steps line
	//static CGFloat dashedPattern[] = {3,3};
    //TODO: make this color a variable
	[[UIColor lightGrayColor] setStroke];
	CGContextSaveGState(context);
	for (int step = 1; step <= _steps; step++) {
		for (int i = 0; i <= _numOfV; ++i) {
			if (i == 0) {
				CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r * step / _steps);
			}
			else {
				//                CGContextSetLineDash(context, 0, dashedPattern, 2);
				CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV) * step / _steps,
				                        _centerPoint.y - _r * cos(i * radPerV) * step / _steps);
			}
		}
		CGContextStrokePath(context);
	}
	CGContextRestoreGState(context);

	//draw lines from center
    //TODO: make this color a variable
	[[UIColor darkGrayColor] setStroke];
	for (int i = 0; i <= _numOfV; i++) {
		CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
		CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
		                        _centerPoint.y - _r * cos(i * radPerV));
		CGContextStrokePath(context);
	}
	//end of base except axis label


	CGContextSetLineWidth(context, 2.0);

	//draw lines
	for (int serie = 0; serie < [_dataSeries count]; serie++) {
		[colors[serie] setStroke];
		for (int i = 0; i <= _numOfV; ++i) {
			CGFloat value = [_dataSeries[serie][i] floatValue];
			if (i == 0) {
				CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r);
			}
			else {
				CGContextAddLineToPoint(context, _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV),
				                        _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV));
			}
		}

		CGContextStrokePath(context);

		//draw data points
		if (_drawPoints) {
			for (int i = 0; i < _numOfV; i++) {
				CGFloat value = [_dataSeries[serie][i] floatValue];
				CGFloat xVal = _centerPoint.x - (value - _minValue) / (_maxValue - _minValue) * _r * sin(i * radPerV);
				CGFloat yVal = _centerPoint.y - (value - _minValue) / (_maxValue - _minValue) * _r * cos(i * radPerV);

				[self.backgroundColor setFill];
				[colors[serie] setFill];
				CGContextFillEllipseInRect(context, CGRectMake(xVal - 4, yVal - 4, 8, 8));
				[self.backgroundColor setFill];
				CGContextFillEllipseInRect(context, CGRectMake(xVal - 2, yVal - 2, 4, 4));
			}
		}
	}

	if (self.showStepText) {
		//draw step label text, alone y axis
        //TODO: make this color a variable
		[[UIColor blackColor] setFill];
		for (int step = 0; step <= _steps; step++) {
			CGFloat value = _minValue + (_maxValue - _minValue) * step / _steps;
			NSString *currentLabel = [NSString stringWithFormat:@"%.0f", value];
			[currentLabel drawInRect:CGRectMake(_centerPoint.x + 3,
			                                    _centerPoint.y - _r * step / _steps - 3,
			                                    20, 10)
			                withFont:scaleFont];
		}
	}
}

@end
