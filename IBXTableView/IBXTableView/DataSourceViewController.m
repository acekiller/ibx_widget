//
//  DataSourceViewController.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataSourceViewController.h"
#import "IBXDataSource.h"
#import "IBXTableViewItem.h"
#import "IBXTableViewEnableItem.h"

@interface DataSourceViewController ()
{
    UITableView * _tableView;
    IBXDataSource * _ibxDataSource;
}

@end

@implementation DataSourceViewController

- (void)dealloc
{
    [_tableView release];
    [_ibxDataSource release];
    
    [super dealloc];
}

#pragma mark - UIView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_tableView == nil) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        
        [_ibxDataSource release];
        _ibxDataSource = [[IBXDataSource alloc] init];
        _tableView.dataSource = _ibxDataSource;
        _tableView.delegate = _ibxDataSource;
        
        IBXTableViewItem * item = [[IBXTableViewItem alloc] init];
        item.title = @"test";
        item.detail = @"has detail";
        item.itemClicked = ^(void) {
            NSLog(@"item clicked");
        };
        [_ibxDataSource addItem:item];
        [item release];
        
        item = [[IBXTableViewItem alloc] init];
        item.title = @"test";
        item.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        item.itemClicked = ^(void) {
            NSLog(@"item clicked");
        };
        [_ibxDataSource addItem:item atSection:1];
        [item release];

        [_ibxDataSource addItem:@"ttt" 
                         detail:nil 
                  accessoryType:UITableViewCellAccessoryCheckmark 
                    itemClicked:^(void) {
            NSLog(@"hello ttt");
        }];
        
        static NSString * KEY_FOR_TEST_ENABLE = @"key_for_test_enable";
        IBXTableViewEnableItem * enableItem = [[IBXTableViewEnableItem alloc] init];
        enableItem.title = @"enable";
        [enableItem setInitialValue:^BOOL{
            return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_FOR_TEST_ENABLE];
        }];
        [enableItem setEnableChanged:^(BOOL newValue) {
            [[NSUserDefaults standardUserDefaults] setBool:newValue forKey:KEY_FOR_TEST_ENABLE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        [_ibxDataSource addItem:enableItem];
        
        [self.view addSubview:_tableView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
