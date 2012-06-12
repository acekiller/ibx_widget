//
//  IBXDataSource.h
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IBXTableViewItem.h"


@interface IBXDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>


- (void)addSection:(NSString *)sectionTitle;

- (void)addItem:(IBXTableViewItem *)item
      atSection:(NSUInteger)section;
- (void)insertItem:(IBXTableViewItem *)item
         atSection:(NSUInteger)section
           atIndex:(NSUInteger)index;
- (void)addItem:(IBXTableViewItem *)item;

- (void)removeItem:(NSIndexPath *)indexPath;

- (void)addItem:(NSString *)title
         detail:(NSString *)detail 
  accessoryType:(UITableViewCellAccessoryType)type
    itemClicked:(void (^)(void))itemClicked;

- (NSIndexPath *)indexPathForItem:(IBXTableViewItem *)item;
- (IBXTableViewItem *)itemFromIndexPath:(NSIndexPath *)indexPath;

@end
