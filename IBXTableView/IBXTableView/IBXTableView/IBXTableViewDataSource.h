//
//  IBXTableViewDataSource.h
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IBXTableViewDataItem;
@class IBXTableViewDataSource;

@protocol IBXTableViewDataSourceDelegate <NSObject>

@required
- (void)dataChanged:(IBXTableViewDataSource *)dataSource;
- (void)itemInserted:(NSUInteger)index dataSource:(IBXTableViewDataSource *)dataSource;
- (void)itemWillDeleted:(NSUInteger)index dataSource:(IBXTableViewDataSource *)dataSource;
- (void)itemUpdated:(NSUInteger)index dataSource:(IBXTableViewDataSource *)dataSource;

@end

@interface IBXTableViewDataSource : NSObject <NSFastEnumeration>

@property (nonatomic, assign) id<IBXTableViewDataSourceDelegate> delegate;

- (void)notifyDataChanged;
- (void)insertItem:(IBXTableViewDataItem *)item atIndex:(NSUInteger)index;
- (void)addItem:(IBXTableViewDataItem *)item;
- (void)addItem:(IBXTableViewDataItem *)item withUpdate:(BOOL)update;
- (void)addItems:(NSArray *)items;
- (void)removeItemAtIndex:(NSUInteger)index;
- (void)removeItemAtIndex:(NSUInteger)index withUpdate:(BOOL)update;
- (void)removeAllItems;
- (void)updateItemAtIndex:(NSUInteger)index;
- (void)cellMovedFrom:(NSUInteger)from index:(NSUInteger)to;

- (NSUInteger)count;
- (IBXTableViewDataItem *)itemAtIndex:(NSUInteger)index;

@end
