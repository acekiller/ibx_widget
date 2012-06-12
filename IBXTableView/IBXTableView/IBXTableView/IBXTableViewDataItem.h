//
//  IBXTableViewDataItem.h
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IBXTableViewCell;

@interface IBXTableViewDataItem : NSObject
{
    
}

@property (nonatomic, assign) NSString * title;
@property (nonatomic, assign) NSString * subTitle;

- (IBXTableViewCell *)tableViewCell;
- (void)updateCell;

@end
