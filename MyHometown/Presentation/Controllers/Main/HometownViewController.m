//
//  MainViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "HometownViewController.h"
#import "ToolboxAnimator.h"
#import "ToolboxViewController.h"
#import "Relationship.h"
#import "Building.h"

#define BUILDING_FRAME CGRectMake(0.0f, 0.0f, 150.0f, 150.0f)

typedef enum {
    SelectedActionNone,
    SelectedActionNewBuilding,
    SelectedActionNewRelationship
}SelectedActionType;

@interface HometownViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *buildingGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *relationshipGestureRecognizer;

@property (strong, nonatomic) ToolboxAnimator *toolboxAnimator;
@property (nonatomic) SelectedActionType selectedAction;

@property (weak, nonatomic) IBOutlet UIView *toolboxContainerView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (strong, nonatomic) Building *relationshipBuilding1;
@property (strong, nonatomic) Building *relationshipBuilding2;

@property (strong, nonatomic) NSMutableArray *buildings;
@property (strong, nonatomic) NSMutableArray *relationships;

- (void)addNewBuilding:(UITapGestureRecognizer *)gestureRecognizer;

- (IBAction)toggleToolbox:(UIBarButtonItem *)sender;
- (void)toggleInstructionsLabel;
- (void)rearrangeViews;

@end

@implementation HometownViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIScreenEdgePanGestureRecognizer *screenEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.toolboxAnimator action:@selector(userDidPan:)];
    screenEdgeGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgeGestureRecognizer];
    
    self.buildingGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewBuilding:)];
    self.buildingGestureRecognizer.numberOfTapsRequired = 1;
    
    self.relationshipGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewRelationship:)];
    self.relationshipGestureRecognizer.numberOfTapsRequired = 1;
    
    self.selectedAction = SelectedActionNone;
}

#pragma mark -
#pragma mark Custom Accessors

- (ToolboxAnimator *)toolboxAnimator {
    if (!_toolboxAnimator) {
        self.toolboxAnimator = [[ToolboxAnimator alloc] initWithToolboxContainerView:self.toolboxContainerView andParentViewController:self];
    }
    return _toolboxAnimator;
}

- (void)setSelectedAction:(SelectedActionType)selectedAction {
    if (_selectedAction != selectedAction) {
        _selectedAction = selectedAction;
        
        [self.view removeGestureRecognizer:self.buildingGestureRecognizer];
        [self.view removeGestureRecognizer:self.relationshipGestureRecognizer];
        
        switch (_selectedAction) {
            case SelectedActionNewBuilding:
                [self.view addGestureRecognizer:self.buildingGestureRecognizer];
                self.instructionsLabel.text = @"Tap anywhere to add a new building";
                break;
            case SelectedActionNewRelationship:
                [self.view addGestureRecognizer:self.relationshipGestureRecognizer];
                self.instructionsLabel.text = @"Tap 2 different buildings to add a relationship";
            default:
                break;
        }
        
        [self toggleInstructionsLabel];
    }
}

- (NSMutableArray *)buildings {
    if (!_buildings) {
        _buildings = [[NSMutableArray alloc] init];
    }
    
    return _buildings;
}

#pragma mark -
#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    
    if ([segueName isEqualToString:TOOLBOX_SEGUE]) {
        ToolboxViewController *toolboxViewController = (ToolboxViewController *) [segue destinationViewController];
        toolboxViewController.panTarget = self.toolboxAnimator;
        toolboxViewController.delegate = self;
    }
}

#pragma mark -
#pragma mark Main View Controller Protocols

- (void)buildingAdditionRequested {
    [self.toolboxAnimator toggleToolbox];
    self.selectedAction = SelectedActionNewBuilding;
}

- (void)relationshipAdditionRequested {
    [self.toolboxAnimator toggleToolbox];
    self.selectedAction = SelectedActionNewRelationship;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)toggleToolbox:(UIBarButtonItem *)sender {
    
    [self.toolboxAnimator toggleToolbox];
}

#pragma mark -
#pragma mark Gesture Recognizer Methods

- (void)addNewBuilding:(UITapGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
    Building *newBuilding = [[Building alloc] initWithFrame:BUILDING_FRAME];
    newBuilding.center = location;
    
    [self.view addSubview:newBuilding];
    [self.buildings addObject:newBuilding];
    
    self.selectedAction = SelectedActionNone;
    
    [self rearrangeViews];
}

- (void)addNewRelationship:(UITapGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    Building *tappedBuilding = nil;
    
    for (Building *building in self.buildings)
    {
        if (CGRectContainsPoint(building.frame, location))
        {
            tappedBuilding = building;
            break;
        }
    }
    
    if (!self.relationshipBuilding1) {
        self.relationshipBuilding1 = tappedBuilding;
        self.relationshipBuilding1.interactionState = BuildingInteractionStateSelected;
    }
    else if(!self.relationshipBuilding2 && ![self.relationshipBuilding1 isEqual:tappedBuilding]) {
        self.relationshipBuilding2 = tappedBuilding;
        self.relationshipBuilding2.interactionState = BuildingInteractionStateSelected;
    }
    
    if (self.relationshipBuilding1 && self.relationshipBuilding2) {
        Relationship *relationship = [[Relationship alloc] initWithEnd1:self.relationshipBuilding1 andEnd2:self.relationshipBuilding2];
        
        [self.view addSubview:relationship];
        [self.relationships addObject:relationship];
        
        self.relationshipBuilding1.interactionState = BuildingInteractionStateNone;
        self.relationshipBuilding2.interactionState = BuildingInteractionStateNone;
        
        self.relationshipBuilding1 = nil;
        self.relationshipBuilding2 = nil;
        
        self.selectedAction = SelectedActionNone;
        
        [self rearrangeViews];
    }
}

#pragma mark -
#pragma mark Other Methods

- (void)toggleInstructionsLabel {
    
    if (self.selectedAction != SelectedActionNone) {
        self.instructionsLabel.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^ {
            self.instructionsLabel.alpha = 1.0;
        }];
    }
    else {
        self.instructionsLabel.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^ {
            self.instructionsLabel.alpha = 0.0;
        }];
    }
}

- (void)rearrangeViews {
    
    for (Relationship *relationship in self.relationships) {
        [self.view sendSubviewToBack:relationship];
    }
    
    for (Building *building in self.buildings) {
        [self.view bringSubviewToFront:building];
    }
    
    [self.view bringSubviewToFront:self.toolboxContainerView];
}

@end
