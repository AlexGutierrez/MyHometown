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

@interface ToolboxViewController : GenericViewController

@property (nonatomic) id<ToolboxViewControllerPanTarget> panTarget;

@end
