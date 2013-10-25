//
//  PieChartViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "PieChartViewController.h"

@interface PieChartViewController () <SChartDatasource, SChartDelegate>

@property (strong, nonatomic) ShinobiChart *chart;
@property (strong, nonatomic) NSDictionary* countrySizes;

- (void)setupLinearChart;

@end

@implementation PieChartViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.countrySizes = @{@"Russia" : @17, @"Canada" : @9.9, @"USA" : @9.6, @"China" : @9.5, @"Brazil" : @8.5, @"Australia" : @7.6};
    
    [self setupLinearChart];
}

#pragma mark -
#pragma mark Chart Data Source

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    
    SChartPieSeries* pieSeries = [[SChartPieSeries alloc] init];
    pieSeries.selectedStyle.protrusion = 10.0f;
    pieSeries.selectionAnimation.duration = @0.4;
    pieSeries.selectedPosition = @0.0;
    return pieSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return self.countrySizes.allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];
    NSString* key = self.countrySizes.allKeys[dataIndex];
    datapoint.name = key;
    datapoint.value = self.countrySizes[key];
    return datapoint;
}

#pragma mark -
#pragma mark Chart Delegate

- (void)sChart:(ShinobiChart *)chart toggledSelectionForRadialPoint:(SChartRadialDataPoint *)dataPoint inSeries:(SChartRadialSeries *)series atPixelCoordinate:(CGPoint)pixelPoint{
    NSLog(@"Selected country: %@", dataPoint.name);
}

#pragma mark -
#pragma mark Other Methods

- (void)setupLinearChart {
    
    if (!self.chart) {
    
        CGFloat margin = 0.0f;
        self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
        self.chart.title = @"Pie chart";
        
        self.chart.licenseKey = SHINOBI_CHARTS_LICENSE_KEY;
        
        self.chart.legend.hidden = YES;
        
        self.chart.datasource = self;
        
        [self.view addSubview:self.chart];
        
    }
}

@end
