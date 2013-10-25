//
//  BarViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "BarChartViewController.h"

@interface BarChartViewController () <SChartDatasource>

@property (strong, nonatomic) ShinobiChart *chart;
@property (strong, nonatomic) NSMutableArray *values;

- (void)setupLinearChart;

@end

@implementation BarChartViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupLinearChart];
}

#pragma mark -
#pragma mark Chart Data Source

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    
    SChartColumnSeries *columnSeries = [SChartColumnSeries new];
    
    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        columnSeries.title = [NSString stringWithFormat:@"Voice Data & IP"];
        columnSeries.style.areaColor = [UIColor blueColor];
        columnSeries.crosshairEnabled = YES;
    } else {
        columnSeries.title = [NSString stringWithFormat:@"Wireless"];
        columnSeries.style.areaColor = [UIColor cyanColor];
        columnSeries.crosshairEnabled = YES;
    }
    
    return columnSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return ((NSDictionary *)self.values[seriesIndex]).allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = ((NSDictionary *)self.values[seriesIndex]).allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = self.values[seriesIndex][key];
    return datapoint;
}

#pragma mark -
#pragma mark Other Methods

- (void)setupLinearChart {
    
    if (!self.chart) {
        self.values = [NSMutableArray new];
        self.values[0] = @{@"SEP" : @3000, @"AUG" : @5000, @"JUL" : @7000, @"JUN" : @4000, @"MAY": @2000};
        self.values[1] = @{@"SEP" : @5000, @"AUG" : @6000, @"JUL" : @10000, @"JUN" : @4500, @"MAY": @4000};
        
        CGFloat margin = 0.0f;
        self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
        self.chart.title = @"Bar chart";
        
        self.chart.licenseKey = SHINOBI_CHARTS_LICENSE_KEY;
        
        // add a pair of axes
        SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
        xAxis.title = @"Months";
        xAxis.rangePaddingLow = @(0.1);
        xAxis.rangePaddingHigh = @(0.1);
        _chart.xAxis = xAxis;
        
        
        SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
        yAxis.title = @"Revenue";
        _chart.yAxis = yAxis;
        
        self.chart.legend.hidden = YES;
        
        // enable gestures
        yAxis.enableGesturePanning = YES;
        yAxis.enableGestureZooming = YES;
        xAxis.enableGesturePanning = YES;
        xAxis.enableGestureZooming = YES;
        
        self.chart.datasource = self;
        
        [self.view addSubview:self.chart];
        
    }
}

@end
