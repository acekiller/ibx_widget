//
//  ViewController.m
//  ApplicationBar
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "IBXToast.h"
#import "IBXStatusBarOverlay.h"

#define TAG_FOR_CREATE_BUTTON   100080
#define TAG_FOR_FEEDBACK_BUTTON 100081

@interface ViewController ()
{
    IBXApplicationBar * _applicationBar;
    IBXNavigationBar * _navigationBar;
}

@end

@implementation ViewController

#pragma mark - self

- (void)barButtonClicked:(NSInteger)buttonTag 
                 withBar:(IBXApplicationBar *)applicationBar
{
    if (buttonTag == TAG_FOR_CREATE_BUTTON) {
        NSLog(@"create button clicked");
    }
    else if (buttonTag == TAG_FOR_FEEDBACK_BUTTON) {
        NSLog(@"feedback button clicked");
    }
}

- (void)navigationBarButtonClicked:(NavigationBarButtonType)type
{
    IBXToast * toast = [[IBXToast alloc] init];
    if (type == NAVIGATION_BAR_BUTTON_LEFT) {
        IBXStatusBarOverlay * overlay = [IBXStatusBarOverlay sharedInstance];
        [overlay showMessage:@"完成"];
    }
    else if (type == NAVIGATION_BAR_BUTTON_RIGHT) {
        [toast setCancelButton:@"cancel" cancelBlock:^{
            NSLog(@"cancel clicked");
        } canceledMessage:@"canceled"];
        [toast showMessage:@"hello cancel"];
        [toast release];
    }
    else if (type == NAVIGATION_BAR_BUTTON_TITLE) {
        [toast setCancelButton:@"cancel" cancelBlock:^{
            NSLog(@"cancel clicked");
        } canceledMessage:@"canceled"];
        [toast showMessage:@"title clicked"];
        [toast release];        
    }
    
}

#pragma mark - UIView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_applicationBar == nil) {
        _applicationBar = [[IBXApplicationBar alloc] init];
        [_applicationBar sizeToFit];
        
        _applicationBar.frame = CGRectMake(0, 
                                           self.view.frame.size.height - _applicationBar.frame.size.height, 
                                           _applicationBar.frame.size.width, 
                                           _applicationBar.frame.size.height);
        
        [_applicationBar addDisplayButton:[UIImage imageNamed:@"icon-plus.png"]
                                withTitle:@"Create" 
                                  withTag:TAG_FOR_CREATE_BUTTON];
        [_applicationBar addOptionButton:@"Feedback"
                                 withTag:TAG_FOR_FEEDBACK_BUTTON];
        
        _applicationBar.barDelegate = self;
    
        
        [self.view addSubview:_applicationBar];
    }
    
    if (_navigationBar == nil) {
        _navigationBar = [[IBXNavigationBar alloc] init];
        _navigationBar.navigationBarDelegate = self;
        [_navigationBar sizeToFit];
        
        _navigationBar.frame = CGRectMake(0, 0, 
                                          _navigationBar.frame.size.width, 
                                          _navigationBar.frame.size.height);
        _navigationBar.titleLabel.text = @"Sample";
        [_navigationBar setButton:@"Right Button Here"
                       buttonType:NAVIGATION_BAR_BUTTON_RIGHT];
        [_navigationBar setButton:@"Left Button"
                       buttonType:NAVIGATION_BAR_BUTTON_LEFT];
        
        [self.view addSubview:_navigationBar];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_applicationBar release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
