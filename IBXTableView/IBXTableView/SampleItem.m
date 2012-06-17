//
//  SampleItem.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SampleItem.h"
#import "IBXTableViewCell.h"

@interface SampleItem () 
{
    IBXTableViewCell * _cell;
}

@end

@implementation SampleItem

- (IBXTableViewCell *)tableViewCell
{
    if (_cell == nil) {
        _cell = [[IBXTableViewCell alloc] init];
        
        UILabel * rightLabel = [[UILabel alloc] init];
        rightLabel.text = @"right";
        [rightLabel sizeToFit];
        _cell.rightIndicator = rightLabel;
        [rightLabel release];
        
        UILabel * leftLabel = [[UILabel alloc] init];
        leftLabel.text = @"left";
        [leftLabel sizeToFit];
        _cell.leftIndicator = leftLabel;
        [leftLabel release];
    }
    
    return _cell;
}

- (void)updateCell
{
    _cell.titleLabel.text = [self title];
    
    [_cell addButton:[UIImage imageNamed:@"icon_edit.png"] title:@"edit" tag:100];
    [_cell addButton:nil title:@"share" tag:101];
    [_cell addRightButton:[UIImage imageNamed:@"icon_trash.png"] title:nil];
    
    [_cell layoutSubviews];    
}


@end
