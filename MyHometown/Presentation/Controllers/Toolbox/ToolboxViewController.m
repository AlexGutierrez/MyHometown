//
//  ToolboxViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "ToolboxViewController.h"

@interface ToolboxViewController ()

@end

@implementation ToolboxViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.panTarget action:@selector(userDidPan:)];
    gestureRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:gestureRecognizer];
}

@end
