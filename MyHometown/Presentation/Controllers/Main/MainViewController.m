//
//  MainViewController.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/21/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "MainViewController.h"
#import "ToolboxAnimator.h"
#import "ToolboxViewController.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) ToolboxAnimator *toolboxAnimator;
@property (weak, nonatomic) IBOutlet UIView *toolboxContainerView;

- (IBAction)toggleToolbox:(UIBarButtonItem *)sender;

@end

@implementation MainViewController

#pragma mark -
#pragma mark Custom Accessors

- (ToolboxAnimator *)toolboxAnimator {
    if (!_toolboxAnimator) {
        self.toolboxAnimator = [[ToolboxAnimator alloc] initWithToolboxContainerView:self.toolboxContainerView andParentViewController:self];
    }
    return _toolboxAnimator;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.toolboxAnimator action:@selector(userDidPan:)];
    gestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
}

#pragma mark -
#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueName = segue.identifier;
    
    if ([segueName isEqualToString:TOOLBOX_SEGUE]) {
        ToolboxViewController *toolboxViewController = (ToolboxViewController *) [segue destinationViewController];
        toolboxViewController.panTarget = self.toolboxAnimator;
    }
}

#pragma mark -
#pragma mark IBActions

- (IBAction)toggleToolbox:(UIBarButtonItem *)sender {
    
    [self.toolboxAnimator toggleToolbox];
}

@end
