//
//  CustomTransitionNavigationController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "CustomTransitionNavigationController.h"
#import "CustomTransitionNavigationAnimator.h"

@interface CustomTransitionNavigationController ()

@property (strong, nonatomic) CustomTransitionNavigationAnimator *animator;

@end

@implementation CustomTransitionNavigationController

#pragma mark -
#pragma mark View Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.animator = [CustomTransitionNavigationAnimator new];
        self.delegate = self.animator;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DDLogWarn(@"%@ - Memory Warning!", [self class]);
}

@end
