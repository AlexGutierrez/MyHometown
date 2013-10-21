//
//  SampleHelper.m
//  ProofOfConcept
//
//  Created by Alex Gutierrez on 10/15/13.
//  Copyright (c) 2013 Alex Gutierrez. All rights reserved.
//

#import "LogHelper.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

@implementation LogHelper

#pragma mark -
#pragma mark Class Methods

+ (instancetype)sharedInstance
{
    static LogHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [LogHelper new];
    });
    return _sharedInstance;
}

#pragma mark -
#pragma mark Public Methods

- (void)setupLogger
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
}

@end
