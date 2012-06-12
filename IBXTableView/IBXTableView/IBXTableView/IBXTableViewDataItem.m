//
//  IBXTableViewDataItem.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXTableViewDataItem.h"
#import "IBXTableViewCell.h"

@interface IBXTableViewDataItem ()
{
    NSString * _title;
    NSString * _subTitle;
    
    IBXTableViewCell * _cell;
}

@end

@implementation IBXTableViewDataItem

@synthesize title = _title;
@synthesize subTitle = _subTitle;

- (IBXTableViewCell *)tableViewCell
{
    if (_cell == nil) {
        _cell = [[IBXTableViewCell alloc] init];
    }
    
    return _cell;
}

- (void)updateCell
{
    _cell.titleLabel.text = _title;
    
    [_cell layoutSubviews];    
}

- (void)dealloc
{
    [_title release];
    [_subTitle release];
    
#warning Big bug
//    [_cell release];
    
    [super dealloc];
}

@end
