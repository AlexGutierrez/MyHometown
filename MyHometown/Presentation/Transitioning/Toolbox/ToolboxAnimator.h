//
//  ToolboxAnimator.h
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolboxViewControllerPanTarget.h"

@interface ToolboxAnimator : UIPercentDrivenInteractiveTransition <ToolboxViewControllerPanTarget>

- (id)initWithParentViewController:(UIViewController *)viewController;

- (void)presentToolbox;
- (void)hideToolbox;

@property (strong, nonatomic, readonly) UIViewController *parentViewController;

@end
