//
//  Building.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/24/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "Building.h"

@interface Building ()

- (void)addGestureRecognizers;

- (void)setupBuilding;
- (void)userDidPan:(UIPanGestureRecognizer *)gestureRecognizer;

@end

@implementation Building

#pragma mark -
#pragma mark View Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupBuilding];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupBuilding];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat lineWidth = 2.0f;
    CGRect borderRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white color
    CGContextSetRGBFillColor(context, 0.5f, 0.0f, 1.0f, 1.0f); // purple color
    CGContextSetLineWidth(context, lineWidth);
    
    // drawing the fill circle with its border
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    
    // rendering
    CGContextFillPath(context);
}

- (void)setupBuilding {
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizers];
}

#pragma mark -
#pragma mark Custom Accessors

- (NSMutableArray *)relationships {
    if (!_relationships) {
        _relationships = [NSMutableArray array];
    }
    
    return _relationships;
}

#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)addGestureRecognizers {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)userDidPan:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if ((gestureRecognizer.state == UIGestureRecognizerStateChanged) ||
        (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y + translation.y);
        [gestureRecognizer setTranslation:CGPointZero inView:self.superview];
    }
}

@end
