//
//  JYLegendView.m
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "JYLegendView.h"

#define COLOR_PADDING 15
#define PADDING 3
#define FONT_SIZE 10
#define LEGEND_ROUND_RADIUS 7
#define CIRCLE_DIAMETER 6

@interface JYLegendView ()

@property (nonatomic, strong) UIFont *legendFont;

@end

@implementation JYLegendView

void CGContextAddRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
	if (2 * radius > rect.size.height) radius = rect.size.height / 2.0;
	if (2 * radius > rect.size.width) radius = rect.size.width / 2.0;
	CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + radius, radius, M_PI, M_PI * 1.5, 0);
	CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, M_PI * 1.5, M_PI * 2, 0);
	CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 2, M_PI * 0.5, 0);
	CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 0.5, M_PI, 0);
	CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + radius);
}

void CGContextFillRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
	CGContextBeginPath(c);
	CGContextAddRoundedRect(c, rect, radius);
	CGContextFillPath(c);
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        [self setDefaultValues];
    }
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues {
    _legendFont = [UIFont systemFontOfSize:FONT_SIZE];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(c, [[UIColor colorWithWhite:0.0 alpha:0.1] CGColor]);
	CGContextFillRoundedRect(c, self.bounds, LEGEND_ROUND_RADIUS);

	CGFloat y = 0;
	for (int i = 0; i < self.titles.count; i++) {
		NSString *title = self.titles[i];
		UIColor *color = self.colors[i];
		if (color) {
			[color setFill];
			CGContextFillEllipseInRect(c, CGRectMake(PADDING + 2,
			                                         PADDING + round(y) + self.legendFont.xHeight / 2 + 1,
			                                         CIRCLE_DIAMETER, CIRCLE_DIAMETER));
		}
		[[UIColor blackColor] set];
		JY_DRAW_TEXT_AT_POINT(title, CGPointMake(COLOR_PADDING + PADDING, y + PADDING), self.legendFont);
		y += [self.legendFont lineHeight];
	}
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGFloat h = [self.legendFont lineHeight] * [self.titles count];
	CGFloat w = 0;
	for (NSString *title in self.titles) {
		CGSize s = JY_TEXT_SIZE(title, self.legendFont);
		w = MAX(w, s.width);
	}
	return CGSizeMake(COLOR_PADDING + w + 2 * PADDING, h + 2 * PADDING);
}

@end
