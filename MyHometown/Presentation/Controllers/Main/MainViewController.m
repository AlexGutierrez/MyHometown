//
//  MainViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "MainViewController.h"
#import "ToolboxAnimator.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) ToolboxAnimator *toolboxAnimator;
@property (weak, nonatomic) IBOutlet UIView *toolboxContainerView;
@property (nonatomic) BOOL toolboxPresented;

- (IBAction)toggleToolbox:(UIBarButtonItem *)sender;

@end

@implementation MainViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.toolboxAnimator = [[ToolboxAnimator alloc] initWithToolboxContainerView:self.toolboxContainerView andParentViewController:self];
    
    UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.toolboxAnimator action:@selector(userDidLeftEdgePan:)];
    gestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
}

#pragma mark -
#pragma mark Custom Accessors

- (void)setToolboxPresented:(BOOL)toolboxPresented {
    if (_toolboxPresented != toolboxPresented) {
        if (_toolboxPresented) {
            [self.toolboxAnimator completeToolboxHidingAnimation];
        }
        else {
            [self.toolboxAnimator completeToolboxPresentationAnimation];
        }
        _toolboxPresented = toolboxPresented;
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction)toggleToolbox:(UIBarButtonItem *)sender {
    
    self.toolboxPresented = !self.toolboxPresented;
}

@end
