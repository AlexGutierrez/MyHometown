//
//  ToolboxViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "ToolboxViewController.h"

@interface ToolboxViewController ()

- (IBAction)requestNewBuilding:(UIButton *)sender;
- (IBAction)requestNewRelationship:(UIButton *)sender;
- (IBAction)requestBuildingRemoval:(UIButton *)sender;
- (IBAction)requestRelationshipRemoval:(UIButton *)sender;
@end

@implementation ToolboxViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.panTarget action:@selector(userDidPan:)];
    gestureRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:gestureRecognizer];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)requestNewBuilding:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(buildingAdditionRequested)]) {
        [self.delegate buildingAdditionRequested];
    }
}

- (IBAction)requestNewRelationship:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(relationshipAdditionRequested)]) {
        [self.delegate relationshipAdditionRequested];
    }
}
- (IBAction)requestBuildingRemoval:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(buildingRemovalRequested)]) {
        [self.delegate buildingRemovalRequested];
    }
}

- (IBAction)requestRelationshipRemoval:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(relationshipRemovalRequested)]) {
        [self.delegate relationshipRemovalRequested];
    }
}

@end
