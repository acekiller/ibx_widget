//
//  IBXTableViewEnableItem.h
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXTableViewItem.h"

@interface IBXTableViewEnableItem : IBXTableViewItem

@property (nonatomic, copy) BOOL (^initialValue)();
@property (nonatomic, copy) void (^enableChanged)(BOOL newValue);

@end
