//
//  BubbleChartViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "BubbleChartViewController.h"

@interface BubbleChartViewController () <SChartDatasource>

@property (strong, nonatomic) ShinobiChart *chart;
@property (strong, nonatomic) NSMutableArray *data;

- (void)setupLinearChart;

@end

@implementation BubbleChartViewController


#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupLinearChart];
    [self loadChartData];
}

#pragma mark -
#pragma mark Chart Data Source

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartBubbleSeries* series = [[SChartBubbleSeries alloc] init];
    series.biggestBubbleDiameterForAutoScaling = @40;
    return series;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return self.data.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    return self.data[dataIndex];
}


#pragma mark -
#pragma mark Other Methods

- (void)setupLinearChart {
    
    if (!self.chart) {
        
        CGFloat margin = 0.0f;
        self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
        self.chart.title = @"Bubble chart";
        
        self.chart.licenseKey = SHINOBI_CHARTS_LICENSE_KEY;
        
        self.chart.datasource = self;
        
        // add a pair of axes
        SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init];
        yAxis.title = @"Day";
        yAxis.rangePaddingHigh = @0.5;
        yAxis.rangePaddingLow = @0.5;
        self.chart.yAxis = yAxis;
        
        SChartAxis *xAxis = [[SChartNumberAxis alloc] init];
        xAxis.rangePaddingHigh = @0.5;
        xAxis.rangePaddingLow = @0.5;
        xAxis.title = @"Hour";
        self.chart.xAxis = xAxis;
        
        // enable gestures
        yAxis.enableGesturePanning = YES;
        yAxis.enableGestureZooming = YES;
        xAxis.enableGesturePanning = YES;
        xAxis.enableGestureZooming = YES;
        
        // add to the view
        [self.view addSubview:self.chart];
        
    }
}


- (void)loadChartData {
    
    self.data = [NSMutableArray new];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"punchcard" ofType:@"json"];
    NSData* json = [NSData dataWithContentsOfFile:filePath];
    NSArray* data = [NSJSONSerialization JSONObjectWithData:json
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    for (NSDictionary* jsonPoint  in data) {
        NSUInteger commits = [((NSNumber*)jsonPoint[@"commits"]) intValue];
        if (commits > 0) {
            SChartBubbleDataPoint* point = [[SChartBubbleDataPoint alloc] init];
            point.xValue = jsonPoint[@"hour"];
            point.yValue = jsonPoint[@"day"];
            point.area =  commits;
            [_data addObject:point];
        }
        
    }
}

@end
