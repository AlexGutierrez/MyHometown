//
//  GraphItem.h
//  MyHometown
//
//  Created by Alex Gutierrez on 10/24/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GraphItemInteractionStateNone,
    GraphItemInteractionStateSelected
}GraphItemInteractionState;

@interface GraphItem : UIView

@property (nonatomic) GraphItemInteractionState interactionState;

@end
