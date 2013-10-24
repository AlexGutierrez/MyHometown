//
//  ToolboxViewControllerDelegate.h
//  MyHometown
//
//  Created by Alex Gutierrez on 10/24/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ToolboxViewControllerDelegate <NSObject>

- (void)buildingAdditionRequested;
- (void)relationshipAdditionRequested;

@end