//
//  IBXTableView.h
//  IBXTableView
//
//  Created by Inbox.com on 4/7/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IBXTableViewDataSource.h"
#import "IBXTableViewCell.h"

typedef enum {
    AnimationTypeNormal,
    AnimationTypeHide,
} RemoveAnimationType;

@protocol IBXTableViewDelegate <NSObject>

@required
- (void)swipeToDelete:(NSUInteger)index;
- (void)cellButtonClicked:(NSUInteger)tag index:(NSUInteger)index;
- (void)cellMovedFrom:(NSUInteger)source index:(NSUInteger)to;

@optional 
- (void)cellDoubleClicked:(NSUInteger)index;

@optional
- (void)blankButtonClicked;

@end

@interface IBXTableView : UIScrollView <IBXTableViewDataSourceDelegate, IBXTableViewCellDelegate>

@property (nonatomic, assign) IBXTableViewDataSource * ibxDataSource;
@property (nonatomic, assign) id<IBXTableViewDelegate> ibxDelegate;

- (void)updateUI;
- (void)layoutFrame;

- (void)removeAnimation:(RemoveAnimationType)type withIndex:(NSInteger)index;

@end
