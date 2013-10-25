//
//  TimeChartViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "TimeChartViewController.h"

@interface TimeChartViewController () <SChartDatasource>

@property (strong, nonatomic) ShinobiChart *chart;
@property (strong, nonatomic) NSMutableArray *timeSeries;

- (void)setupLinearChart;

@end

@implementation TimeChartViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupLinearChart];
}

#pragma mark -
#pragma mark Chart Data Source

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return self.timeSeries.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    return self.timeSeries[dataIndex];
}

#pragma mark -
#pragma mark Other Methods

- (void)setupLinearChart {
    
    if (!self.chart) {
        
        CGFloat margin = 0.0f;
        self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
        self.chart.title = @"Time chart";
        
        self.chart.licenseKey = SHINOBI_CHARTS_LICENSE_KEY;
        
        self.chart.datasource = self;
        
        // add a pair of axes
        // add a discontinuous date axis
        SChartDiscontinuousDateTimeAxis *xAxis = [[SChartDiscontinuousDateTimeAxis alloc] init];
        
        // a time period that defines the weekends
        SChartRepeatedTimePeriod* weekends = [[SChartRepeatedTimePeriod alloc] initWithStart:[self dateFromString:@"02-01-2010"]
                                                                                   andLength:[SChartDateFrequency dateFrequencyWithDay:2]
                                                                                andFrequency:[SChartDateFrequency dateFrequencyWithWeek:1]];
        [xAxis addExcludedRepeatedTimePeriod:weekends];
        xAxis.title = @"Date";
        _chart.xAxis = xAxis;
        
        SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
        yAxis.title = @"Price (USD)";
        _chart.yAxis = yAxis;
        
        // create some data
        [self loadChartData];
        
        // enable gestures
        yAxis.enableGesturePanning = YES;
        yAxis.enableGestureZooming = YES;
        xAxis.enableGesturePanning = YES;
        xAxis.enableGestureZooming = YES;
        
        // add to the view
        [self.view addSubview:_chart];

        
    }
}


- (void)loadChartData {
    
    self.timeSeries = [NSMutableArray new];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"AppleStockPrices" ofType:@"json"];
    
    NSData* json = [NSData dataWithContentsOfFile:filePath];
    
    NSArray* data = [NSJSONSerialization JSONObjectWithData:json
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    for (NSDictionary* jsonPoint  in data) {
        SChartDataPoint* datapoint = [self dataPointForDate:jsonPoint[@"date"]
                                                   andValue:jsonPoint[@"close"]];
        [self.timeSeries addObject:datapoint];
    }
    
}


#pragma mark - 
#pragma mark Utility Methods

- (NSDate*) dateFromString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    return [dateFormatter dateFromString:date];
}

- (SChartDataPoint*)dataPointForDate:(NSString*)date andValue:(NSNumber*)value {
    SChartDataPoint* dataPoint = [SChartDataPoint new];
    dataPoint.xValue = [self dateFromString:date];
    dataPoint.yValue = value;
    return dataPoint;
}


@end
