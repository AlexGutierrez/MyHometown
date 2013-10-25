//
//  CustomTransitionNavigationAnimator.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/25/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "CustomTransitionNavigationAnimator.h"
#import "FadeTransition.h"

@implementation CustomTransitionNavigationAnimator

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return [FadeTransition new];
}

@end
