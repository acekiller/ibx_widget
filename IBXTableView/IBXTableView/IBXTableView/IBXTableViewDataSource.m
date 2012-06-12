//
//  IBXTableViewDataSource.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXTableViewDataSource.h"

@interface IBXTableViewDataSource ()
{
    NSMutableArray * _items;
    id<IBXTableViewDataSourceDelegate> _delegate;
}

@end

@implementation IBXTableViewDataSource

@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSUInteger)count
{
    return [_items count];
}

- (IBXTableViewDataItem *)itemAtIndex:(NSUInteger)index
{
    return [_items objectAtIndex:index];
}

- (void)notifyDataChanged
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataChanged:)]) {
        [_delegate dataChanged:self];
    }
}

#pragma mark - countByEnumeratingWithState

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
                                  objects:(id [])buffer 
                                    count:(NSUInteger)len
{
 	NSUInteger count = 0;
	// This is the initialization condition, so we'll do one-time setup here.
	// Ensure that you never set state->state back to 0, or use another method to detect initialization
	// (such as using one of the values of state->extra).
	if(state->state == 0)
	{
		// We are not tracking mutations, so we'll set state->mutationsPtr to point into one of our extra values,
		// since these values are not otherwise used by the protocol.
		// If your class was mutable, you may choose to use an internal variable that is updated when the class is mutated.
		// state->mutationsPtr MUST NOT be NULL.
		state->mutationsPtr = &state->extra[0];
	}
	// Now we provide items, which we track with state->state, and determine if we have finished iterating.
	if(state->state < [_items count])
	{
		// Set state->itemsPtr to the provided buffer.
		// Alternate implementations may set state->itemsPtr to an internal C array of objects.
		// state->itemsPtr MUST NOT be NULL.
		state->itemsPtr = buffer;
		// Fill in the stack array, either until we've provided all items from the list
		// or until we've provided as many items as the stack based buffer will hold.
		while((state->state < [_items count]) && (count < len))
		{
			// For this sample, we generate the contents on the fly.
			// A real implementation would likely just be copying objects from internal storage.
			buffer[count] = [_items objectAtIndex:state->state];
			state->state++;
			count++;
		}
	}
	else
	{
		// We've already provided all our items, so we signal we are done by returning 0.
		count = 0;
	}
	return count;
   
}

#pragma mark - Item

- (void)insertItem:(IBXTableViewDataItem *)item atIndex:(NSUInteger)index
{
    [_items insertObject:item atIndex:index];
    
    NSUInteger lastIndex = [_items indexOfObject:item];
    if (_delegate && [_delegate respondsToSelector:@selector(itemInserted:dataSource:)]) {
        [_delegate itemInserted:lastIndex dataSource:self];
    }
}

- (void)addItem:(IBXTableViewDataItem *)item
{
    [self addItem:item withUpdate:YES];
}

- (void)addItem:(IBXTableViewDataItem *)item withUpdate:(BOOL)update
{
    [_items addObject:item];
    
    if (update) {
        NSUInteger index = [_items indexOfObject:item];
        if (_delegate && [_delegate respondsToSelector:@selector(itemInserted:dataSource:)]) {
            [_delegate itemInserted:index dataSource:self];
        }    
    }
}

- (void)addItems:(NSArray *)items
{
    [_items addObjectsFromArray:items];
    
    [self notifyDataChanged];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self removeItemAtIndex:index withUpdate:YES];
}

- (void)removeItemAtIndex:(NSUInteger)index withUpdate:(BOOL)update
{
    if (update) {
        if (_delegate && [_delegate respondsToSelector:@selector(itemWillDeleted:dataSource:)]) {
            [_delegate itemWillDeleted:index dataSource:self];
        }
    }
    
    [_items removeObjectAtIndex:index];    
}

- (void)cellMovedFrom:(NSUInteger)from index:(NSUInteger)to
{
    IBXTableViewDataItem * item = [_items objectAtIndex:from];
    [item retain];
    [_items removeObject:item];
    [_items insertObject:item atIndex:to];
    [item release];
}

- (void)removeAllItems
{
    [_items removeAllObjects];
    
    [self notifyDataChanged];
}

- (void)updateItemAtIndex:(NSUInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(itemUpdated:dataSource:)]) {
        [_delegate itemUpdated:index dataSource:self];
    }
}

#pragma mark - dealloc

- (void)dealloc
{
    [_items release];
    
    _delegate = nil;
    
    [super dealloc];
}

@end
