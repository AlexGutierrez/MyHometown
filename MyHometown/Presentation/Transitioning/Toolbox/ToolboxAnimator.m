//
//  ToolboxAnimator.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "ToolboxAnimator.h"
#import "ToolboxViewController.h"

@interface ToolboxAnimator () <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@property (strong, nonatomic) UIViewController *parentViewController;

@end

@implementation ToolboxAnimator

#pragma mark -
#pragma mark Object Lifecycle

- (instancetype)initWithParentViewController:(UIViewController *)viewController {
    
    if (self = [super init]) {
        self.parentViewController = viewController;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)presentToolbox {
    self.presenting = YES;
    
    ToolboxViewController *toolboxViewController = [self.parentViewController.storyboard instantiateViewControllerWithIdentifier:TOOLBOX_VIEWCONTROLLER];
    toolboxViewController.modalPresentationStyle = UIModalPresentationCustom;
    toolboxViewController.transitioningDelegate = self;
    toolboxViewController.panTarget = self;
    [self.parentViewController presentViewController:toolboxViewController animated:YES completion:nil];
}

- (void)hideToolbox {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Gesture Recognizers

- (void)userDidEdgePan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.parentViewController.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.parentViewController.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // We're being invoked via a gesture recognizer – we are necessarily interactive
        self.interactive = YES;
        
        // The side of the screen we're panning from determines whether this is a presentation (left) or dismissal (right)
        if (location.x < CGRectGetMidX(gestureRecognizer.view.bounds)) {
            [self presentToolbox];
        }
        else {
            [self hideToolbox];
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // Determine our ratio between the left edge and the right edge. This means our dismissal will go from 1...0.
        CGFloat ratio = location.x / CGRectGetWidth(self.parentViewController.view.bounds);
        [self updateInteractiveTransition:ratio];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Depending on our state and the velocity, determine whether to cancel or complete the transition.
        if (self.isPresenting) {
            if (velocity.x > 0) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
        }
        else {
            if (velocity.x < 0) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
        }
    }

}

#pragma mark - 
#pragma mark UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.isInteractive) {
        return self;
    }
    
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    
    if (self.isInteractive) {
        return self;
    }
    
    return nil;
}

#pragma mark -
#pragma mark UIViewControllerAnimatedTransitioning Methods

- (void)animationEnded:(BOOL)transitionCompleted {
    // Reset to our default state
    self.interactive = NO;
    self.presenting = NO;
    self.transitionContext = nil;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Used only in non-interactive transitions, despite the documentation
    return 0.3f;
}

// For non-interactive transitions
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.isInteractive) {
        // nop as per documentation
    }
    else {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        CGRect endFrame = [[transitionContext containerView] bounds];
        
        if (self.isPresenting) {
            // The order of these matters – determines the view hierarchy order.
            [transitionContext.containerView addSubview:fromViewController.view];
            [transitionContext.containerView addSubview:toViewController.view];
            
            CGRect startFrame = endFrame;
            startFrame.origin.x -= CGRectGetWidth(endFrame);
            
            toViewController.view.frame = startFrame;
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                toViewController.view.frame = endFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
        else {
            [transitionContext.containerView addSubview:toViewController.view];
            [transitionContext.containerView addSubview:fromViewController.view];
            
            endFrame.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                fromViewController.view.frame = endFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    }
}

#pragma mark -
#pragma mark UIViewControllerInteractiveTransitioning Methods

// Just for the start of the interaction
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    if (self.isPresenting) {
        // The order of these matters – determines the view hierarchy order.
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        endFrame.origin.x -= CGRectGetWidth(endFrame);
    }
    else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
    }
    
    toViewController.view.frame = endFrame;
}

#pragma mark -
#pragma mark UIPercentDrivenInteractiveTransition Overridden Methods

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Presenting goes from 0...1 and dismissing goes from 1...0
    CGRect containerViewFrame = [[transitionContext containerView] bounds];
    CGRect frame = CGRectOffset(containerViewFrame, -CGRectGetWidth(containerViewFrame) * (1.0f - percentComplete), 0);
    
    if (self.isPresenting)
    {
        toViewController.view.frame = frame;
    }
    else {
        fromViewController.view.frame = frame;
    }
}

- (void)finishInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    if (self.isPresenting)
    {
        [UIView animateWithDuration:0.5f animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        endFrame = CGRectOffset(endFrame, -CGRectGetWidth(endFrame), 0);
        
        [UIView animateWithDuration:0.5f animations:^{
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
}

- (void)cancelInteractiveTransition {
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    if (self.isPresenting)
    {
        endFrame = CGRectOffset(endFrame, -CGRectGetWidth(endFrame), 0);
        
        [UIView animateWithDuration:0.5f animations:^{
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:NO];
        }];
    }
}

@end
