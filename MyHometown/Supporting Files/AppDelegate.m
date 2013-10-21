//
//  AppDelegate.m
//  MyHometown
//
//  Created by Alex Gutierrez on 10/18/13.
//  Copyright (c) 2013 PoC. All rights reserved.
//

#import "AppDelegate.h"
#import "GenericService.h"
#import "LogHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[LogHelper sharedInstance] setupLogger];
    [[GenericService sharedInstance] setupDatabase];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[GenericService sharedInstance] cleanUpDatabase];
}

@end
