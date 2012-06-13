//
//  ViewController.m
//  LockScreen
//
//  Created by 剑锋 屠 on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "IBXLockScreenViewController.h"

@interface ViewController ()
{
    UISwitch * lockSwitcher;
}

@end

@implementation ViewController

- (void)dealloc
{
    [lockSwitcher release];
    
    [super dealloc];
}

- (void)switchChanged:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch * lSwitcher = sender;
        if ([lSwitcher isOn]) {
            IBXLockScreenViewController * lockViewController = [[IBXLockScreenViewController alloc] init];
            [self presentModalViewController:lockViewController animated:YES];
            [lockViewController release];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (lockSwitcher == nil) {
        lockSwitcher = [[UISwitch alloc] init];
        [lockSwitcher sizeToFit];
        [lockSwitcher addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:lockSwitcher];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
