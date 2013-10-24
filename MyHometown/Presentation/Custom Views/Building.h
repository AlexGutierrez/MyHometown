//
//  Building.h
//  MyHometown
//
//  Created by Alex Gutierrez on 10/24/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BuildingInteractionStateNone,
    BuildingInteractionStateSelected
}BuildingInteractionState;

@interface Building : UIView

@property (nonatomic) BuildingInteractionState interactionState;

@end
