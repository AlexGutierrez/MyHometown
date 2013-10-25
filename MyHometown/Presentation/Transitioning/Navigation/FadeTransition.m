//
//  FadeTransition.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "FadeTransition.h"

@implementation FadeTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get the two view controllers
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Get the container view - where the animation has to happen
    UIView *containerView = [transitionContext containerView];
    
    // Get the views from both VCs
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    // Add the views to the container view
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    // Prepare the views for the zoom in transition
    toView.alpha = 0.0f;
    
    // Animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:0
                     animations:^{
                         toVC.view.alpha = 1.f;
                     }
                     completion:^(BOOL finished) {
                         // Getting rid of the old VC view
                         [fromVC.view removeFromSuperview];
                         // Telling the context that we're done
                         [transitionContext completeTransition:YES];
                     }];
}


@end
