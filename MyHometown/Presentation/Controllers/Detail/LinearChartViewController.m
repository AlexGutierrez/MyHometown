//
//  LinearChartViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "LinearChartViewController.h"

@interface LinearChartViewController () <SChartDatasource>

@property (strong, nonatomic) ShinobiChart *chart;

- (void)setupLinearChart;

@end

@implementation LinearChartViewController

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
    
    SChartLineSeries *lineSeries = [SChartLineSeries new];
    
    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        lineSeries.title = [NSString stringWithFormat:@"y = cos(x)"];
        lineSeries.style.areaColor = [UIColor purpleColor];
        lineSeries.crosshairEnabled = YES;
    } else {
        lineSeries.title = [NSString stringWithFormat:@"y = sin(x)"];
        lineSeries.style.areaColor = [UIColor cyanColor];
        lineSeries.crosshairEnabled = YES;
    }
    
    lineSeries.style.showFill = YES;
    
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 100;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    // both functions share the same x-values
    double xValue = dataIndex / 20.0;
    datapoint.xValue = [NSNumber numberWithDouble:xValue];
    
    // compute the y-value for each series
    if (seriesIndex == 0) {
        datapoint.yValue = [NSNumber numberWithDouble:cosf(xValue)];
    } else {
        datapoint.yValue = [NSNumber numberWithDouble:sinf(xValue)];
    }
    
    return datapoint;
}

#pragma mark -
#pragma mark Other Methods

- (void)setupLinearChart {
    
    if (!self.chart) {
        CGFloat margin = 0.0f;
        self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
        self.chart.title = @"Linear chart";
        
        self.chart.licenseKey = SHINOBI_CHARTS_LICENSE_KEY;
        
        // add a pair of axes
        SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
        xAxis.title = @"X Value";
        xAxis.style.majorTickStyle.showTicks = YES;
        _chart.xAxis = xAxis;
        
        
        SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
        yAxis.title = @"Y Value";
        yAxis.rangePaddingLow = @(0.1);
        yAxis.rangePaddingHigh = @(0.1);
        _chart.yAxis = yAxis;
        
        self.chart.legend.hidden = NO;
        
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
