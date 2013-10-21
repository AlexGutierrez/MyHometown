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

@property (nonatomic) BOOL toolboxPresented;

- (IBAction)toggleToolbox:(UIBarButtonItem *)sender;

@end

@implementation MainViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.toolboxAnimator = [[ToolboxAnimator alloc] initWithParentViewController:self];
    
    UIScreenEdgePanGestureRecognizer *gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.toolboxAnimator action:@selector(userDidEdgePan:)];
    gestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *detailViewController = segue.destinationViewController;
    
    detailViewController.transitioningDelegate = self;
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
}

#pragma mark -
#pragma mark Custom Accessors

- (void)setToolboxPresented:(BOOL)toolboxPresented
{
    if (toolboxPresented != _toolboxPresented) {
        
        if (!_toolboxPresented) {
            [self.toolboxAnimator presentToolbox];
        }
        else {
            [self.toolboxAnimator hideToolbox];
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
