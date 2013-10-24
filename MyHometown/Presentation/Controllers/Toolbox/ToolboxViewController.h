//
//  ToolboxViewController.h
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericViewController.h"
#import "ToolboxViewControllerPanTarget.h"
#import "ToolboxViewControllerDelegate.h"

@interface ToolboxViewController : GenericViewController

@property (strong, nonatomic) id<ToolboxViewControllerPanTarget> panTarget;
@property (weak, nonatomic) id<ToolboxViewControllerDelegate> delegate;

@end
