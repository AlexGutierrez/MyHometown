//
//  Relationship.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/24/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "Relationship.h"

@interface Relationship ()

@property (weak, nonatomic) UIView *end1;
@property (weak, nonatomic) UIView *end2;

- (void)recalculatePosition;

@end

@implementation Relationship

#pragma mark -
#pragma mark View lifecycle

- (instancetype)initWithEnd1:(UIView *)end1 andEnd2:(UIView *)end2 {
    
    if (self = [super init]) {
        self.end1 = end1;
        self.end2 = end2;
        
        [self.end1 addObserver:self forKeyPath:@"center" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
        [self.end2 addObserver:self forKeyPath:@"center" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self recalculatePosition];
    }
    
    return self;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [self.end1 removeObserver:self forKeyPath:@"center"];
    [self.end2 removeObserver:self forKeyPath:@"center"];
}

#pragma mark -
#pragma mark Drawing Methods

- (void)recalculatePosition {
    
    CGPoint sourcePoint = self.end1.center;
    CGPoint destinyPoint = self.end2.center;
    
    CGFloat xDist = (destinyPoint.x - sourcePoint.x);
    CGFloat yDist = (destinyPoint.y - sourcePoint.y);
    CGFloat distance = fabsf(sqrt((xDist * xDist) + (yDist * yDist)));
    
    CGFloat rotationAngle = atan2f(yDist, xDist);
    
    CGPoint midPoint = {(sourcePoint.x + destinyPoint.x) / 2, (sourcePoint.y + destinyPoint.y) / 2};
    
    self.transform = CGAffineTransformIdentity;
    
    self.frame = CGRectMake(sourcePoint.x, sourcePoint.y, distance, 10.0);
    
    self.transform = CGAffineTransformMakeRotation(rotationAngle);
    self.center = midPoint;
}

#pragma mark -
#pragma mark Key Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"center"]) {
        [self recalculatePosition];
    }
}


@end
