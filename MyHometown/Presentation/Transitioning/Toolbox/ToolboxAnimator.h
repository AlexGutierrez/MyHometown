//
//  ToolboxAnimator.h
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolboxAnimator : NSObject

- (id)initWithToolboxContainerView:(UIView *)toolboxContainerView andParentViewController:(UIViewController *)parentViewController;

- (void)completeToolboxPresentationAnimation;
- (void)completeToolboxHidingAnimation;

- (void)userDidLeftEdgePan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
    
@end
