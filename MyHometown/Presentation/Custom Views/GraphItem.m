//
//  GraphItem.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/24/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "GraphItem.h"
#import "UIView+Glow.h"

@implementation GraphItem

#pragma mark -
#pragma mark Custom Accessors

- (void)setInteractionState:(GraphItemInteractionState)interactionState {
    if (_interactionState != interactionState) {
        _interactionState = interactionState;
        
        if (interactionState == GraphItemInteractionStateSelected) {
            [self startGlowingWithColor:[UIColor whiteColor] intensity:0.6f];
        }
        else {
            [self stopGlowing];
        }
    }
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    self.gestureRecognizers = [NSArray array];
}

@end
