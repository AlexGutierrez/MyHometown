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
#define ALERT_VIEW_CANCEL_INDEX 0
#define ALERT_VIEW_OK_INDEX 1

typedef enum {
    SelectedActionNone,
    SelectedActionNewBuilding,
    SelectedActionNewRelationship,
    SelectedActionRemoveBuilding,
    SelectedActionRemoveRelationship
}SelectedActionType;

@interface HometownViewController ()

@property (strong, nonatomic) UITapGestureRecognizer *buildingAdditionGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *relationshipAdditionGestureRecognizer;

@property (strong, nonatomic) UITapGestureRecognizer *buildingRemovalGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *relationshipRemovalGestureRecognizer;

@property (strong, nonatomic) ToolboxAnimator *toolboxAnimator;
@property (nonatomic) SelectedActionType selectedAction;

@property (weak, nonatomic) IBOutlet UIView *toolboxContainerView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (strong, nonatomic) Building *tappedBuilding1;
@property (strong, nonatomic) Building *tappedBuilding2;
@property (strong, nonatomic) Relationship *tappedRelationship;

@property (strong, nonatomic) NSMutableArray *buildings;
@property (strong, nonatomic) NSMutableArray *relationships;

- (void)addNewBuilding:(UITapGestureRecognizer *)gestureRecognizer;
- (void)addNewRelationship:(UITapGestureRecognizer *)gestureRecognizer;
- (void)confirmBuildingRemoval:(UITapGestureRecognizer *)gestureRecognizer;
- (void)confirmRelationshipRemoval:(UITapGestureRecognizer *)gestureRecognizer;

- (void)removeBuilding;
- (void)removeRelationship:(Relationship *)relationship;

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
    
    self.buildingAdditionGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewBuilding:)];
    self.buildingAdditionGestureRecognizer.numberOfTapsRequired = 1;
    
    self.relationshipAdditionGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewRelationship:)];
    self.relationshipAdditionGestureRecognizer.numberOfTapsRequired = 1;
    
    self.buildingRemovalGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmBuildingRemoval:)];
    self.buildingRemovalGestureRecognizer.numberOfTapsRequired = 1;
    
    self.relationshipRemovalGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmRelationshipRemoval:)];
    self.relationshipRemovalGestureRecognizer.numberOfTapsRequired = 1;
    
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
        
        [self.view removeGestureRecognizer:self.buildingAdditionGestureRecognizer];
        [self.view removeGestureRecognizer:self.relationshipAdditionGestureRecognizer];
        [self.view removeGestureRecognizer:self.buildingRemovalGestureRecognizer];
        [self.view removeGestureRecognizer:self.relationshipRemovalGestureRecognizer];
        
        self.tappedBuilding1 = nil;
        self.tappedBuilding2 = nil;
        self.tappedRelationship = nil;
        
        switch (_selectedAction) {
            case SelectedActionNewBuilding:
                [self.view addGestureRecognizer:self.buildingAdditionGestureRecognizer];
                self.instructionsLabel.text = @"Tap anywhere to add a new building";
                break;
            case SelectedActionNewRelationship:
                [self.view addGestureRecognizer:self.relationshipAdditionGestureRecognizer];
                self.instructionsLabel.text = @"Tap 2 different buildings to add a relationship";
                break;
            case SelectedActionRemoveBuilding:
                [self.view addGestureRecognizer:self.buildingRemovalGestureRecognizer];
                self.instructionsLabel.text = @"Tap a building to remove it";
                break;
            case SelectedActionRemoveRelationship:
                [self.view addGestureRecognizer:self.relationshipRemovalGestureRecognizer];
                self.instructionsLabel.text = @"Tap a relationship to remove it";
            default:
                break;
        }
        
        [self toggleInstructionsLabel];
    }
}

- (NSMutableArray *)buildings {
    if (!_buildings) {
        _buildings = [NSMutableArray array];
    }
    
    return _buildings;
}

- (NSMutableArray *)relationships {
    if (!_relationships) {
        _relationships = [NSMutableArray array];
    }
    
    return _relationships;
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

- (void)buildingRemovalRequested {
    [self.toolboxAnimator toggleToolbox];
    self.selectedAction = SelectedActionRemoveBuilding;
}

- (void)relationshipRemovalRequested {
    [self.toolboxAnimator toggleToolbox];
    self.selectedAction = SelectedActionRemoveRelationship;
}

#pragma mark -
#pragma mark Alert View Protocols

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == ALERT_VIEW_OK_INDEX) {
        if (self.selectedAction == SelectedActionRemoveBuilding) {
            [self removeBuilding];
        }
        else if (self.selectedAction == SelectedActionRemoveRelationship) {
            [self removeRelationship:self.tappedRelationship];
        }
    }
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
    
    if (tappedBuilding) {
        if (!self.tappedBuilding1) {
            self.tappedBuilding1 = tappedBuilding;
            self.tappedBuilding1.interactionState = GraphItemInteractionStateSelected;
        }
        else if(!self.tappedBuilding2 && ![self.tappedBuilding1 isEqual:tappedBuilding]) {
            self.tappedBuilding2 = tappedBuilding;
            self.tappedBuilding2.interactionState = GraphItemInteractionStateSelected;
        }
        
        if (self.tappedBuilding1 && self.tappedBuilding2) {
            Relationship *relationship = [[Relationship alloc] initWithEnd1:self.tappedBuilding1 andEnd2:self.tappedBuilding2];
            
            [self.view addSubview:relationship];
            [self.relationships addObject:relationship];
            [self.tappedBuilding1.relationships addObject:relationship];
            [self.tappedBuilding2.relationships addObject:relationship];
            
            self.tappedBuilding1.interactionState = GraphItemInteractionStateNone;
            self.tappedBuilding2.interactionState = GraphItemInteractionStateNone;
            
            self.tappedBuilding1 = nil;
            self.tappedBuilding2 = nil;
            
            self.selectedAction = SelectedActionNone;
            
            [self rearrangeViews];
        }
    }
}

- (void)confirmBuildingRemoval:(UITapGestureRecognizer *)gestureRecognizer {
    
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
    
    if (tappedBuilding) {
        self.tappedBuilding1 = tappedBuilding;
        //tappedBuilding.interactionState = GraphItemInteractionStateSelected;
        
        [[[UIAlertView alloc] initWithTitle:@"Confirmation"
                                    message:@"Do you really want to remove this building and its relationships?"
                                   delegate:self
                          cancelButtonTitle:@"Ehh... No"
                          otherButtonTitles:@"Yeah, sure", nil] show];
    }
}

- (void)confirmRelationshipRemoval:(UITapGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    Relationship *tappedRelationship = nil;
    
    
    for (Relationship *relationship in self.relationships)
    {
        if (CGRectContainsPoint(relationship.frame, location))
        {
            tappedRelationship = relationship;
            break;
        }
    }
    
    if (tappedRelationship) {
        self.tappedRelationship = tappedRelationship;
        //tappedRelationship.interactionState = GraphItemInteractionStateSelected;
        
        [[[UIAlertView alloc] initWithTitle:@"Confirmation"
                                    message:@"Do you really want to remove this relationship?"
                                   delegate:self
                          cancelButtonTitle:@"Ehh... No"
                          otherButtonTitles:@"Yeah, sure", nil] show];
    }
}

#pragma mark -
#pragma mark Selected Actions

- (void)removeBuilding {
    if (self.tappedBuilding1) {
        
        //tappedBuilding.interactionState = GraphItemInteractionStateNone;

        // TO-DO: Remove this when the app supports persistency
        NSArray *relationshipsToRemove = [NSArray arrayWithArray:self.tappedBuilding1.relationships];
        for (Relationship *relationship in relationshipsToRemove) {
            [self removeRelationship:relationship];
        }
        
        [self.tappedBuilding1 removeFromSuperview];
        [self.buildings removeObject:self.tappedBuilding1];
    }
    
    self.selectedAction = SelectedActionNone;
}

- (void)removeRelationship:(Relationship *)tappedRelationship {
    if (tappedRelationship) {
        
        //tappedRelationship.interactionState = GraphItemInteractionStateNone;
        [tappedRelationship removeFromSuperview];
        [self.relationships removeObject:tappedRelationship];
        
        // TO-DO: Remove this when the app supports persistency
        
        for (Building *building in self.buildings) {
            Relationship *relationshipToRemove = nil;
            
            for (Relationship *buildingRelationship in building.relationships) {
                if ([buildingRelationship isEqual:tappedRelationship]) {
                    relationshipToRemove = buildingRelationship;
                    break;
                }
            }
            
            [building.relationships removeObject:relationshipToRemove];
        }
    }
    
    if ([tappedRelationship isEqual:self.tappedRelationship]) {
        self.selectedAction = SelectedActionNone;
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
