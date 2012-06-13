//
//  ViewController.m
//  LockScreen
//
//  Created by 剑锋 屠 on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "IBXLockScreenView.h"
#import "IBXLockScreenAgent.h"

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
            IBXLockScreenView * screenView = [IBXLockScreenView getView];
            [self.view addSubview:screenView];
        }
        else {
            [IBXLockScreenAgent clearPassword];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (lockSwitcher == nil) {
        lockSwitcher = [[UISwitch alloc] init];
        [lockSwitcher sizeToFit];
        [lockSwitcher setOn:[IBXLockScreenAgent isSaved]];
        [lockSwitcher addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:lockSwitcher];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
