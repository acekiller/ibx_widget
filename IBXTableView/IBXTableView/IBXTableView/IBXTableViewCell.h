//
//  IBXTableViewCell.h
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBXTableViewCell;

@protocol IBXTableViewCellDelegate <NSObject>

@required
- (void)toggled:(IBXTableViewCell *)cell;
- (void)buttonClicked:(NSUInteger)tag cell:(IBXTableViewCell *)cell;
- (void)swipeDetected:(UISwipeGestureRecognizerDirection) direction
                 cell:(IBXTableViewCell *)cell;
- (void)longPress:(UILongPressGestureRecognizer *)recognizer 
             cell:(IBXTableViewCell *)cell;
- (void)slideStart:(IBXTableViewCell *)cell;
- (void)slideEnd:(IBXTableViewCell *)cell;

@optional
- (void)doubleClicked:(IBXTableViewCell *)cell;

@end

@interface IBXTableViewCell : UIView
{
    BOOL _extended;
}

@property (nonatomic, assign) id<IBXTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL extended;
@property (nonatomic, readonly) UILabel * titleLabel;
@property (nonatomic, readonly) UILabel * subTitleLabel;
@property (nonatomic, readonly) UIView * buttonView;
@property (nonatomic, retain) UIView * rightIndicator;
@property (nonatomic, retain) UIView * leftIndicator;

- (void)toggleView;
- (void)resizeWithToggle;
- (void)addButton:(UIImage *)icon 
            title:(NSString *)title
              tag:(NSUInteger)tag;
- (void)clearButtons;
- (void)setFocus:(BOOL)focus;
- (void)slide:(CGFloat)delta;

@end
