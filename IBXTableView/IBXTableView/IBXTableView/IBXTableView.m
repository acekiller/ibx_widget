//
//  IBXTableView.m
//  IBXTableView
//
//  Created by Inbox.com on 4/7/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import "IBXTableView.h"
#import "IBXTableViewDataItem.h"
#import "IBXTableViewCell.h"

@interface IBXTableView () 
{
    IBXTableViewDataSource * _ibxDataSource;
    id<IBXTableViewDelegate> _ibxDelegate;
    NSMutableArray * _cells;
    
    NSInteger _needLayoutFrame;
    
    IBXTableViewCell * _moveCell;
    CGFloat cellStartY;
    CGFloat touchStartY;
    
    BOOL _layouting;
    
    UIButton * _blankButton;
}

@end

@implementation IBXTableView

@synthesize ibxDelegate = _ibxDelegate;
@synthesize ibxDataSource = _ibxDataSource;


- (void)dealloc
{
    _ibxDataSource.delegate = nil;
    _ibxDataSource = nil;
    
    [_cells release];
    
    [_blankButton release];
    
    [super dealloc];
}


- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        
        _cells = [[NSMutableArray alloc] init];
        
        _blankButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_blankButton addTarget:self action:@selector(blankButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_blankButton];        
    }
    
    return self;
}

#pragma mark - blank button

- (void)blankButtonClicked:(id)sender
{
    if (_ibxDelegate != nil && [_ibxDelegate respondsToSelector:@selector(blankButtonClicked)]) {
        [_ibxDelegate blankButtonClicked];
    }
}

#pragma mark - layout

- (void)layoutFrame
{
    CGFloat y = _moveCell.frame.size.height;
    for (IBXTableViewCell * cell in _cells) {
        if (cell == _moveCell) continue;
            
        if ((y - cell.frame.size.height / 2.)<_moveCell.frame.origin.y) {
            cell.frame = CGRectMake(0, y - _moveCell.frame.size.height, 320, cell.frame.size.height);                
        }
        else {
            cell.frame = CGRectMake(0, y, 320, cell.frame.size.height);                
        }
        y += cell.frame.size.height;        
    }
    
    _blankButton.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
        
    self.contentSize = CGSizeMake(self.contentSize.width, MAX(y, self.frame.size.height+1));    
}

- (BOOL)needLayoutFrame
{
    CGFloat y = _moveCell.frame.size.height;
    for (IBXTableViewCell * cell in _cells) {
        if (cell == _moveCell) continue;
        
        if ((y + cell.frame.size.height / 2.)<_moveCell.frame.origin.y) {
            if (cell.frame.origin.y != y - _moveCell.frame.size.height) return YES;
        }
        else {
            if (cell.frame.origin.y != y) return YES;
        }
        y += cell.frame.size.height;
    }
    
    return NO;
}

- (NSUInteger)indexOfMoveCell
{
    NSUInteger index = 0;
    for (IBXTableViewCell * cell in _cells) {
        if (cell == _moveCell) continue;
        if (cell.frame.origin.y < _moveCell.frame.origin.y) index++;
    }    
    
    return index;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _blankButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (_needLayoutFrame > 0) {
        [self layoutFrame];
        
        _needLayoutFrame--;
    }

}

- (void)updateUI
{
    _needLayoutFrame++;
    
    [self setNeedsLayout];
}

#pragma mark - changed

- (void)swipeDetected:(UISwipeGestureRecognizerDirection)direction 
                 cell:(IBXTableViewCell *)cell
{
    if (direction == UISwipeGestureRecognizerDirectionRight) {
        NSUInteger index = [_cells indexOfObject:cell];
        if (index != NSNotFound && _ibxDelegate 
            && [_ibxDelegate respondsToSelector:@selector(swipeToDelete:)]) {
            [_ibxDelegate swipeToDelete:index];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer 
             cell:(IBXTableViewCell *)cell
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _moveCell = cell;
        [_moveCell setFocus:YES];
        [self bringSubviewToFront:_moveCell];
        
        cellStartY = cell.frame.origin.y;
        touchStartY = [recognizer locationInView:self].y;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat currentY = [recognizer locationInView:self].y;
        CGRect frame = cell.frame;
        frame.origin.y = cellStartY + (currentY - touchStartY);
        cell.frame = frame;
        
        [UIView animateWithDuration:0.2 
                              delay:0 
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
            [self layoutFrame];
        } completion:^(BOOL finished) {
        }];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {        
        NSUInteger fromIndex = [_cells indexOfObject:_moveCell];
        NSUInteger newIndex = [self indexOfMoveCell];
        
        [_moveCell retain];
        [_cells removeObject:_moveCell];
        [_cells insertObject:_moveCell atIndex:newIndex];
        [_moveCell release];

        [_moveCell setFocus:NO];
        _moveCell = nil;
        
        [UIView animateWithDuration:0.2 animations:^(void) {
            [self layoutFrame];
        } completion:^(BOOL finished) {
            if (_ibxDelegate && [_ibxDelegate respondsToSelector:@selector(cellMovedFrom:index:)]) {
                [_ibxDelegate cellMovedFrom:fromIndex index:newIndex];
                [_ibxDataSource cellMovedFrom:fromIndex index:newIndex];
            }
        }];
    }
}

- (void)slideStart:(IBXTableViewCell *)cell
{
    self.scrollEnabled = NO;
}

- (void)slideEnd:(IBXTableViewCell *)cell
{
    self.scrollEnabled = YES;
}

- (void)toggled:(IBXTableViewCell *)cell
{
    [UIView animateWithDuration:0.2 animations:^(void) {
        [cell resizeWithToggle];
        [self layoutFrame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^(void) {
            BOOL changed = NO;
            for (IBXTableViewCell * c in _cells) {
                if (c.extended && c!=cell) {
                    c.extended = NO;
                    changed = YES;
                    [c resizeWithToggle];
                }
            }
            if (changed) [self layoutFrame];
        }];
    }];
}

- (void)buttonClicked:(NSUInteger)tag cell:(IBXTableViewCell *)cell
{
    NSUInteger index = [_cells indexOfObject:cell];
    if (index != NSNotFound && _ibxDelegate 
        && [_ibxDelegate respondsToSelector:@selector(cellButtonClicked:index:)]) {
        [_ibxDelegate cellButtonClicked:tag index:index];
    }
}

- (void)doubleClicked:(IBXTableViewCell *)cell
{
    NSUInteger index = [_cells indexOfObject:cell];
    if (index != NSNotFound && _ibxDelegate 
        && [_ibxDelegate respondsToSelector:@selector(cellDoubleClicked:)]) {
        [_ibxDelegate cellDoubleClicked:index];
    }    
}

#pragma mark - data

- (void)itemInserted:(NSUInteger)index 
          dataSource:(IBXTableViewDataSource *)dataSource
{
    IBXTableViewDataItem * item = [dataSource itemAtIndex:index];
    IBXTableViewCell * cell = [item tableViewCell];
    [item updateCell];
    cell.delegate = self;
    [_cells insertObject:cell atIndex:index];
    [self addSubview:cell];
    
    cell.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^(void) {
        [self layoutFrame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^(void) {
            cell.alpha = 1; 
        }];
    }];
}

- (void)itemWillDeleted:(NSUInteger)index
             dataSource:(IBXTableViewDataSource *)dataSource
{
    IBXTableViewDataItem * item = [dataSource itemAtIndex:index];
    IBXTableViewCell * cell = [item tableViewCell];
    [UIView animateWithDuration:0.2 animations:^(void) {
        CGRect frame = cell.frame;
        frame.origin.x += cell.frame.size.width;
        cell.frame = frame;
    } completion:^(BOOL finished) {
        [cell removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^(void) {
            [_cells removeObject:cell];
            [self layoutFrame];
        }];
    }];
}

- (void)itemUpdated:(NSUInteger)index 
         dataSource:(IBXTableViewDataSource *)dataSource
{
    IBXTableViewDataItem * item = [dataSource itemAtIndex:index];
    [item updateCell];
    [UIView animateWithDuration:0.2 animations:^(void) {
        [self layoutFrame];
    } completion:^(BOOL finished) {
    }];
    
}

- (void)dataChanged:(IBXTableViewDataSource *)dataSource
{
    for (IBXTableViewCell * cell in _cells) {
        [cell removeFromSuperview];
    }
    [_cells removeAllObjects];

    for (IBXTableViewDataItem * item in dataSource) {
        IBXTableViewCell * cell = [item tableViewCell];
        cell.delegate = self;
        [item updateCell];
        [_cells addObject:cell];
        [self addSubview:cell];
    }

    [self updateUI];
}

- (void)setIbxDataSource:(IBXTableViewDataSource *)ibxDataSource
{
    _ibxDataSource = ibxDataSource;
    ibxDataSource.delegate = self;
}


@end
