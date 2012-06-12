//
//  IBXDataSource.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXDataSource.h"

@interface IBXDataSource () 
{
    NSMutableArray * _itemLists;
    NSMutableArray * _sectionTitles;
}

@end

@implementation IBXDataSource

- (void)dealloc
{
    [_itemLists release];
    [_sectionTitles release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _itemLists = [[NSMutableArray alloc] init];
        _sectionTitles = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_itemLists count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * items = [_itemLists objectAtIndex:section];
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"ibx_cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                       reuseIdentifier:identifer] autorelease];
    }
    
    NSArray * items = [_itemLists objectAtIndex:indexPath.section];
    IBXTableViewItem * item = [items objectAtIndex:indexPath.row];
    [item layout:cell];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * items = [_itemLists objectAtIndex:indexPath.section];
    IBXTableViewItem * item = [items objectAtIndex:indexPath.row];
    if (item.itemClicked != nil) {
        item.itemClicked();
    }
}

#pragma mark - self

- (void)addSection:(NSString *)sectionTitle
{
    [_sectionTitles addObject:([sectionTitle length] > 0) ? sectionTitle : @""];
    NSMutableArray * items = [[NSMutableArray alloc] init];
    [_itemLists addObject:items];
    [items release];
}

- (NSMutableArray *)itemsAtSection:(NSInteger)section
{
    while ([_itemLists count] <= section) {
        [self addSection:nil];
    }

    return [_itemLists objectAtIndex:section];
}

- (void)insertItem:(IBXTableViewItem *)item 
         atSection:(NSUInteger)section 
           atIndex:(NSUInteger)index
{
    NSMutableArray * items = [self itemsAtSection:section];
    [items insertObject:item atIndex:index];
}

- (void)addItem:(IBXTableViewItem *)item
      atSection:(NSUInteger)section
{
    NSMutableArray * items = [self itemsAtSection:section];
    [items addObject:item];
}

- (void)addItem:(IBXTableViewItem *)item
{
    [self addItem:item atSection:0];
}

- (void)addItem:(NSString *)title 
         detail:(NSString *)detail 
  accessoryType:(UITableViewCellAccessoryType)type 
    itemClicked:(void (^)(void))itemClicked
{
    IBXTableViewItem * item = [[IBXTableViewItem alloc] init];
    item.title = title;
    item.detail = detail;
    item.accessoryType = type;
    item.itemClicked = itemClicked;
    [self addItem:item];
    [item release];
}

- (void)removeItem:(NSIndexPath *)indexPath
{
    NSMutableArray * items = [self itemsAtSection:indexPath.section];
    [items removeObjectAtIndex:indexPath.row];
}

- (NSIndexPath *)indexPathForItem:(IBXTableViewItem *)item
{
    int i=0;
    for (NSArray * array in _itemLists) {
        for (IBXTableViewItem * temp in array) {
            if (temp == item) {
                return [NSIndexPath indexPathForRow:[array indexOfObject:temp] inSection:i];
            }
        }
        
        i++;
    }
                        
    return nil;
}

- (IBXTableViewItem *)itemFromIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    for (NSArray * array in _itemLists) {
        
        if (section == 0) {
            
            if ([array count] > indexPath.row) {
                return [array objectAtIndex:indexPath.row];
            }
            
            break;
        }
        
        section--;
    }
    
    return nil;
}

@end
