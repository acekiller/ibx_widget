//
//  IBXTableViewEnableItem.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXTableViewEnableItem.h"

@interface IBXTableViewEnableItem ()
{
    UISwitch * _switcher;
}

@end

@implementation IBXTableViewEnableItem

@synthesize initialValue = _initialValue;
@synthesize enableChanged = _enableChanged;

- (void)dealloc
{
    [_initialValue release];
    [_enableChanged release];
    [_switcher release];
    
    [super dealloc];
}

- (void)switchValueChanged:(id)sender
{
    if (_enableChanged == nil) return;
    if (![sender isKindOfClass:[UISwitch class]]) return;
    
    UISwitch * switcher = (UISwitch *)sender;
    _enableChanged(switcher.on);
}

- (void)layout:(UITableViewCell *)cell
{
    [super layout:cell];
    
    _switcher = [[UISwitch alloc] init];
    [_switcher addTarget:self
                 action:@selector(switchValueChanged:) 
       forControlEvents:UIControlEventValueChanged];
    
    cell.accessoryView = _switcher;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_initialValue != nil) {
        _switcher.on = _initialValue();
    }

}

@end
