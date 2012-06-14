//
//  AppDelegate.m
//  LockScreen
//
//  Created by 剑锋 屠 on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "IBXLockScreenAgent.h"
#import "IBXLockScreenView.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (void)checkPassword
{
    if ([IBXLockScreenAgent isSaved]) {
        IBXLockScreenView * screenView = [IBXLockScreenView getView:self.window.frame];
        [self.window addSubview:screenView];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    ViewController * controller = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.viewController = controller;
    
//    self.window.rootViewController = navigationController;
    [self.window addSubview:navigationController.view];
    [navigationController release];
    
    [self checkPassword];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self checkPassword];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
