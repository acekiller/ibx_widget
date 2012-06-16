//
//  IBXTableViewItem.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXTableViewItem.h"

@interface IBXTableViewItem () 
{
    NSString * _title;
    NSString * _detail;
}

@end

@implementation IBXTableViewItem

@synthesize title = _title;
@synthesize detail = _detail;
@synthesize itemClicked = _itemClicked;
@synthesize accessoryType = _accessoryType;

- (void)dealloc
{
    [_title release];
    [_detail release];
    [_itemClicked release];
    
    [super dealloc];
}

- (id)init 
{
    self = [super init];
    if (self) {
        _accessoryType = UITableViewCellAccessoryNone;
    }
    
    return self;
}

- (void)layout:(UITableViewCell *)cell
{
    cell.textLabel.text = self.title;
    cell.detailTextLabel.text = [self.detail length] > 0 ? self.detail : @"";
    cell.accessoryView = nil;
    cell.accessoryType = self.accessoryType;
}

@end
