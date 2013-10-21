//
//  ToolboxAnimator.h
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToolboxViewControllerPanTarget.h"

@interface ToolboxAnimator : NSObject <ToolboxViewControllerPanTarget>

- (id)initWithToolboxContainerView:(UIView *)toolboxContainerView andParentViewController:(UIViewController *)parentViewController;

- (void)completeToolboxPresentationAnimation;
- (void)completeToolboxHidingAnimation;
    
@end
