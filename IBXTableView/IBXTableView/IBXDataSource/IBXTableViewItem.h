//
//  IBXTableViewItem.h
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBXTableViewItem : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) void (^itemClicked)();
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

- (void)layout:(UITableViewCell *)cell;

@end
