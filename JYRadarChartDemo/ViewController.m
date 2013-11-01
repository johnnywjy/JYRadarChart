//
//  ViewController.m
//  JYRadarChartDemo
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "ViewController.h"
#import "JYRadarChart.h"

@interface ViewController () {
	JYRadarChart *p;
	JYRadarChart *p2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	p = [[JYRadarChart alloc] initWithFrame:CGRectMake(30, 20, 200, 200)];


    //notice: you should repeat the 1st value at last
	NSArray *a1 = @[@(81), @(97), @(87), @(60), @(65), @(77), @(81)];
	NSArray *a2 = @[@(91), @(87), @(33), @(77), @(78), @(96), @(91)];
	p.dataSeries = @[a1, a2];
	p.steps = 4;
	p.backgroundColor = [UIColor whiteColor];
	p.r = 60;
	p.minValue = 20;
	p.maxValue = 120;
	p.attributes = @[@"Attack", @"Defense", @"Speed", @"HP", @"MP", @"IQ"];
	p.showLegend = YES;
	[p setTitles:@[@"archer", @"footman"]];
	[self.view addSubview:p];


	[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateData) userInfo:nil repeats:YES];


	p2 = [[JYRadarChart alloc] initWithFrame:CGRectMake(10, 220, 220, 200)];
	p2.drawPoints = YES;
    NSArray *b1 = @[@(81), @(97), @(87), @(60), @(85), @(77), @(73), @(74), @(53), @(82), @(65), @(81)];
	NSArray *b2 = @[@(91), @(87), @(43), @(77), @(78), @(96), @(51), @(65), @(77), @(55), @(84), @(91)];
	p2.dataSeries = @[b1, b2];
	p2.steps = 3;
	p2.backgroundColor = [UIColor grayColor];
//	[p2 setTitles:@[@"aaax", @"xxxx"]];
//    p2.r = 100;
//    p2.dataTitles=@[@"AAA",@"BBB",@"CCC",@"DDD",@"EEE",@"FFF"];
	[self.view addSubview:p2];
}

- (void)updateData {
	int n = 7;
	NSMutableArray *a = [NSMutableArray array];
	NSMutableArray *b = [NSMutableArray array];
	NSMutableArray *c = [NSMutableArray array];


	for (int i = 0; i < n - 1; i++) {
		a[i] = [NSNumber numberWithInt:arc4random() % 40 + 80];
		b[i] = [NSNumber numberWithInt:arc4random() % 50 + 70];
		c[i] = [NSNumber numberWithInt:arc4random() % 60 + 60];
	}
	a[n - 1] = a[0];
	b[n - 1] = b[0];
	c[n - 1] = c[0];

	p.dataSeries = @[a, b, c];
	[p setTitles:@[@"iPhone", @"pizza", @"hard drive"]];
	[p setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
