//
//  ToolboxAnimator.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "ToolboxAnimator.h"

#define TOOLBOX_FRAME CGRectMake(0, 64, 350, 704)

@interface ToolboxAnimator ()

// defines if the toolbox has been displayed already or not
@property (nonatomic, getter = toolboxIsPresented) BOOL toolboxPresented;
// defines if the user can interact with the toolbox via a pan gesture
@property (nonatomic, getter = toolboxIsInteractive) BOOL toolboxInteractive;
@property (strong, nonatomic) UIView *toolboxContainerView;
@property (strong, nonatomic) UIViewController *parentViewController;

- (void)presentToolbox:(BOOL)animated;
- (void)hideToolbox:(BOOL)animated;
- (void)updateToolboxFrame:(CGFloat)ratio;

@end

@implementation ToolboxAnimator

#pragma mark -
#pragma mark Object Lifecycle

- (id)initWithToolboxContainerView:(UIView *)toolboxContainerView andParentViewController:(UIViewController *)parentViewController {
    
    if (self = [super init]) {
        self.toolboxContainerView = toolboxContainerView;
        self.parentViewController = parentViewController;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Custom Accessors

- (void)toggleToolbox {
    if (self.toolboxIsPresented) {
        [self completeToolboxHidingAnimation];
    }
    else {
        [self completeToolboxPresentationAnimation];
    }
}

#pragma mark -
#pragma mark Toolbox Toggling Animation

- (void)completeToolboxPresentationAnimation {
    
    [self hideToolbox:NO];
    [self presentToolbox:YES];
    self.toolboxPresented = YES;
    self.toolboxInteractive = NO;
}

- (void)completeToolboxHidingAnimation {
    
    [self presentToolbox:NO];
    [self hideToolbox:YES];
    self.toolboxPresented = NO;
    self.toolboxInteractive = NO;
}

- (void)presentToolbox:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^ {
            CGRect endFrame = TOOLBOX_FRAME;
            self.toolboxContainerView.frame = endFrame;
        }];
    }
    else {
        CGRect endFrame = TOOLBOX_FRAME;
        self.toolboxContainerView.frame = endFrame;
    }
}

- (void)hideToolbox:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^ {
            CGRect endFrame = CGRectOffset(TOOLBOX_FRAME, -CGRectGetWidth(self.toolboxContainerView.frame), 0);
            self.toolboxContainerView.frame = endFrame;
        }];
    }
    else {
        CGRect endFrame = CGRectOffset(TOOLBOX_FRAME, -CGRectGetWidth(self.toolboxContainerView.frame), 0);
        self.toolboxContainerView.frame = endFrame;
    }
}

- (void)updateToolboxFrame:(CGFloat)ratio
{
    // Presenting goes from 0...1 and dismissing goes from 1...0
    if (ratio <= 1.0 && ratio >= 0.0) {
        CGRect frame = CGRectOffset(TOOLBOX_FRAME, -CGRectGetWidth(TOOLBOX_FRAME) * (1.0f - ratio), 0);
        self.toolboxContainerView.frame = frame;
    }
}

#pragma mark -
#pragma mark Pan Target Protocol Methods

- (void)userDidPan:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.parentViewController.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.parentViewController.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (location.x < CGRectGetMidX(gestureRecognizer.view.bounds)) {
            if (!self.toolboxIsPresented) {
                [self hideToolbox:NO];
                self.toolboxInteractive = YES;
            }
        }
        else {
            if (self.toolboxIsPresented) {
                [self presentToolbox:NO];
                self.toolboxInteractive = YES;
            }
        }
    }
    else if (self.toolboxInteractive) {
        
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            // Determine our ratio between the left edge and the right edge. This means our dismissal will go from 1...0.
            CGFloat ratio = location.x / CGRectGetWidth(self.toolboxContainerView.bounds);
            [self updateToolboxFrame:ratio];
        }
        else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (velocity.x > 0) {
                [self presentToolbox:YES];
                self.toolboxPresented = YES;
            }
            else {
                [self hideToolbox:YES];
                self.toolboxPresented = NO;
            }
            
            self.toolboxInteractive = NO;
        }
        
    }
}

@end
