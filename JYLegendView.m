//
//  JYLegendView.m
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "JYLegendView.h"

#define COLORPADDING 15
#define PADDING 3
#define FONT_SIZE 10

@implementation JYLegendView

void CGContextAddRoundedRect(CGContextRef c, CGRect rect, CGFloat radius) {
	if(2 * radius > rect.size.height) radius = rect.size.height / 2.0;
	if(2 * radius > rect.size.width) radius = rect.size.width / 2.0;
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [[UIColor colorWithWhite:0.0 alpha:0.1] CGColor]);
    CGContextFillRoundedRect(c, self.bounds, 7);

    CGFloat y = 0;
    for (int i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        UIColor *color = self.colors[i];
        if(color) {
            [color setFill];
            CGContextFillEllipseInRect(c, CGRectMake(PADDING + 2, PADDING + round(y) + self.titlesFont.xHeight / 2 + 1, 6, 6));
        }
        [[UIColor blackColor] set];
        [title drawAtPoint:CGPointMake(COLORPADDING + PADDING, y + PADDING) withFont:self.titlesFont];
        y += [self.titlesFont lineHeight];

    }
}

- (UIFont *)titlesFont {
    if(_titlesFont == nil)
        _titlesFont = [UIFont systemFontOfSize:FONT_SIZE];
    return _titlesFont;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat h = [self.titlesFont lineHeight] * [self.titles count];
    CGFloat w = 0;
    for(NSString *title in self.titles) {
        CGSize s = [title sizeWithFont:self.titlesFont];
        w = MAX(w, s.width);
    }
    return CGSizeMake(COLORPADDING + w + 2 * PADDING, h + 2 * PADDING);
}

@end
