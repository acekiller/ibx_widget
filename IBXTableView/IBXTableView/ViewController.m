//
//  ViewController.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DataSourceViewController.h"
#import "IBXTableViewDataSource.h"
#import "IBXTableViewDataItem.h"
#import "SampleItem.h"

@interface ViewController ()
{
    IBXTableView * _tableView;
    IBXTableViewDataSource * _tableViewDataSource;
    
    UIButton * _addButton;
    UIButton * _insertButton;
    UIButton * _updateButton;
    UIButton * _sampleDataSourceButton;
}

@end

@implementation ViewController

- (void)dealloc
{
    [_tableView release];
    [_tableViewDataSource release];
    
    [_addButton release];
    [_updateButton release];
    [_insertButton release];
    [_sampleDataSourceButton release];
    
    [super dealloc];
}

#pragma mark - IBXTableView

- (void)swipeToDelete:(NSUInteger)index
{
    [_tableViewDataSource removeItemAtIndex:index];
}

- (void)cellButtonClicked:(NSUInteger)tag index:(NSUInteger)index
{
    
}

- (void)cellDoubleClicked:(NSUInteger)index
{
    NSLog(@"double clicked");
}

- (void)cellMovedFrom:(NSUInteger)source index:(NSUInteger)to
{
    
}

- (void)blankButtonClicked
{
    [self createItem];
}

- (void)createItem
{
    SampleItem * item = [[SampleItem alloc] init];
    item.title = [NSString stringWithFormat:@"%@", [NSDate date]];
    [_tableViewDataSource addItem:item];
    [item release];    
}

- (void)sampleButtonClicked:(id)sender
{
    if (sender == _addButton) {
        [self createItem];
    }
    else if (sender == _insertButton) {
        SampleItem * item = [[SampleItem alloc] init];
        item.title = [NSString stringWithFormat:@"%@", [NSDate date]];
        [_tableViewDataSource insertItem:item atIndex:0];
        [item release];        
    }
    else if (sender == _updateButton) {
        SampleItem * item = (SampleItem *)[_tableViewDataSource itemAtIndex:0];
        item.title = @"hello world. 111,hello world. 111,hello world. 111,hello world. 111,hello world. 111,hello world. 111,";
        [_tableViewDataSource updateItemAtIndex:0];
    }
    else if (sender == _sampleDataSourceButton) {
        DataSourceViewController * controller = [[DataSourceViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark - UIView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_tableView == nil) {
        _tableViewDataSource = [[IBXTableViewDataSource alloc] init];
        _tableView = [[IBXTableView alloc] init];
        _tableView.ibxDelegate = self;
        _tableView.ibxDataSource = _tableViewDataSource;
                
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        _tableView.frame = frame;
        
        [self.view addSubview:_tableView];
    }
    
    CGFloat buttonY = 350;
    
    if (_addButton == nil) {
        _addButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _addButton.backgroundColor = [UIColor redColor];
        _addButton.frame = CGRectMake(280, buttonY, 30, 30);
        [_addButton addTarget:self
                       action:@selector(sampleButtonClicked:) 
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
    }
    
    if (_insertButton == nil) {
        _insertButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _insertButton.backgroundColor = [UIColor greenColor];
        _insertButton.frame = CGRectMake(240, buttonY, 30, 30);
        [_insertButton addTarget:self 
                          action:@selector(sampleButtonClicked:) 
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_insertButton];
    }
    
    if (_updateButton == nil) {
        _updateButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _updateButton.backgroundColor = [UIColor blueColor];
        _updateButton.frame = CGRectMake(200, buttonY, 30, 30);
        [_updateButton addTarget:self 
                          action:@selector(sampleButtonClicked:) 
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_updateButton];
    }
    
    if (_sampleDataSourceButton == nil) {
        _sampleDataSourceButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _sampleDataSourceButton.backgroundColor = [UIColor blackColor];
        _sampleDataSourceButton.frame = CGRectMake(10, buttonY, 30, 30);
        [_sampleDataSourceButton addTarget:self 
                                    action:@selector(sampleButtonClicked:)
                          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sampleDataSourceButton];
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
