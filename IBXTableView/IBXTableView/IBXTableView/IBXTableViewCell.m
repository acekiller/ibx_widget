//
//  IBXTableViewCell.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "IBXTableViewCell.h"

#define DEFAULT_CELL_HEIGHT 44
#define DEFAULT_PADDING 5

@interface IBXTableViewCell ()
{
    UILabel * _titleLabel;
    UILabel * _subTitleLabel;
    UIScrollView * _buttonView;
    
    id<IBXTableViewCellDelegate> _delegate;
    
    CGPoint _startPoint;
    
    UIView * _rightIndicator;
    UIView * _leftIndicator;
}

@end

@implementation IBXTableViewCell

@synthesize extended = _extended;
@synthesize delegate = _delegate;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize buttonView = _buttonView;
@synthesize rightIndicator = _rightIndicator;
@synthesize leftIndicator = _leftIndicator;


- (void)dealloc
{
    _delegate = nil;
    
    [_buttonView release];
    [_titleLabel release];
    [_subTitleLabel release];
    [_rightIndicator release];
    [_leftIndicator release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, 320, DEFAULT_CELL_HEIGHT);
        
        _buttonView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, DEFAULT_CELL_HEIGHT, 310, 0)];
        _buttonView.backgroundColor = [UIColor blackColor];
        [self addSubview:_buttonView];
                
        UILongPressGestureRecognizer * longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                      action:@selector(longReceived:)];
        [self addGestureRecognizer:longRecognizer];
        [longRecognizer release];
        
//        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
//        [tapRecognizer setNumberOfTapsRequired:2];
//        [self addGestureRecognizer:tapRecognizer];
//        [tapRecognizer release];
    }
    return self;
}

#pragma mark - get view

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 20)];
        _titleLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

#pragma mark - gesture

- (void)longReceived:(UILongPressGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(longPress:cell:)]) {
        [_delegate longPress:recognizer cell:self];
    }
}

//- (void)tapReceived:(UITapGestureRecognizer *)recoginzer
//{
//    NSLog(@"tap tap tap");
//}

#pragma mark - resize

- (BOOL)confirmDelete
{
    return self.frame.origin.x > self.frame.size.width / 3.;
}

- (void)resizeWithToggle
{
    CGRect frame = self.frame;  
    frame.size.height = _extended ? 2*DEFAULT_CELL_HEIGHT : DEFAULT_CELL_HEIGHT;
    self.frame = frame;
    
    frame = _buttonView.frame;
    frame.size.height = _extended ? DEFAULT_CELL_HEIGHT : 0;
    _buttonView.backgroundColor = _extended ? [UIColor blackColor] : [UIColor clearColor];
    _buttonView.contentSize = CGSizeMake(_buttonView.contentSize.width, frame.size.height);
    _buttonView.frame = frame;
}

- (void)toggleView
{
    _extended = !_extended;
    if (_delegate && [_delegate respondsToSelector:@selector(toggled:)]) {
        [_delegate toggled:self];
    }
}

#pragma mark - slide

- (void)slide:(CGFloat)delta
{
    if (_delegate && [_delegate respondsToSelector:@selector(slideStart:)]) {
        [_delegate slideStart:self];
    }
}

- (void)slideEnd
{
    if (_delegate && [_delegate respondsToSelector:@selector(slideEnd:)]) {
        [_delegate slideEnd:self];
    }    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.frame.origin.x == 0) {
        UITouch * touch = [touches anyObject];
        if ([touch tapCount] == 1) {
            [self performSelector:@selector(toggleView) withObject:nil afterDelay:0.2];
        }
    }
    else {
        [self slideEnd];
        
        if ([self confirmDelete]) {
            if (_delegate && [_delegate respondsToSelector:@selector(swipeDetected:cell:)]) {
                [_delegate swipeDetected:UISwipeGestureRecognizerDirectionRight cell:self];
            }
        }
        else {
            [UIView animateWithDuration:0.2 animations:^(void) {
                CGRect frame = self.frame;
                frame.origin.x = 0;
                self.frame = frame;
                
                _rightIndicator.hidden = YES;
                _leftIndicator.hidden = YES;
            }];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    _startPoint = [touch locationInView:self.superview];    
    
    if ([touch tapCount] == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                                 selector:@selector(toggleView) 
                                                   object:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(doubleClicked:)]) {
            [_delegate doubleClicked:self];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    CGPoint current = [touch locationInView:self.superview];    
    
    CGRect frame = self.frame;
    frame.origin.x = current.x - _startPoint.x;
    self.frame = frame;
    
    int visiblePadding = 5;
    _rightIndicator.hidden = (frame.origin.x <= visiblePadding);
    _leftIndicator.hidden = (frame.origin.x >= -visiblePadding);
    if (frame.origin.x != 0) {
        [self slide:frame.origin.x];
        
        if (frame.origin.x > visiblePadding) {
            if (_rightIndicator != nil && _rightIndicator.superview != self) {
                [self addSubview:_rightIndicator];
                [self sendSubviewToBack:_rightIndicator];
            }
            _rightIndicator.frame = CGRectMake(-frame.origin.x + DEFAULT_PADDING, 
                                               (frame.size.height - _rightIndicator.frame.size.height) / 2., 
                                               _rightIndicator.frame.size.width, 
                                               _rightIndicator.frame.size.height);
            _rightIndicator.alpha = [self confirmDelete] ? 1 : 0.3;
        }
        
        if (frame.origin.x < -visiblePadding) {
            if (_leftIndicator != nil && _leftIndicator.superview != self) {
                [self addSubview:_leftIndicator];
                [self sendSubviewToBack:_leftIndicator];
            }
            _leftIndicator.frame = CGRectMake(frame.size.width - frame.origin.x - _leftIndicator.frame.size.width - DEFAULT_PADDING, 
                                              (frame.size.height - _leftIndicator.frame.size.height) / 2., 
                                              _leftIndicator.frame.size.width, 
                                              _leftIndicator.frame.size.height);
        }
    }
}

#pragma mark - button

- (void)optionButtonClicked:(id)sender
{
    if (![sender isKindOfClass:[UIButton class]]) return;
    
    UIButton * button = (UIButton *)sender;
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClicked:cell:)]) {
        [_delegate buttonClicked:button.tag cell:self];
    }
}

- (void)addButton:(UIImage *)icon
            title:(NSString *)title 
              tag:(NSUInteger)tag
{
    CGFloat x = 0;
    for (UIView * view in _buttonView.subviews) {
        if (![view isKindOfClass:[UIButton class]]) continue;
            
        if (CGRectGetMaxX(view.frame) > x) x = CGRectGetMaxX(view.frame);
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (icon != nil) {
        [button setImage:icon forState:UIControlStateNormal];
        [button sizeToFit];
        CGFloat width = button.frame.size.width * DEFAULT_CELL_HEIGHT / button.frame.size.height + 2 * DEFAULT_PADDING;
        button.frame = CGRectMake(x, 0, width, DEFAULT_CELL_HEIGHT);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, DEFAULT_PADDING, 0, DEFAULT_PADDING);
    }
    else {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button sizeToFit];
        button.frame = CGRectMake(x, 0, button.frame.size.width + 2 * DEFAULT_PADDING, DEFAULT_CELL_HEIGHT);
    }
    [button addTarget:self
               action:@selector(optionButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    button.showsTouchWhenHighlighted = YES;
    button.tag = tag;
    [_buttonView addSubview:button];
    _buttonView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + button.frame.size.width, DEFAULT_CELL_HEIGHT);
}

- (void)clearButtons
{
    NSArray * buttons = [NSArray arrayWithArray:_buttonView.subviews];
    for (UIView * view in buttons) {
        if ([view isKindOfClass:[UIButton class]]) [view removeFromSuperview];
    }
}

#pragma mark - setFocus

- (void)setFocus:(BOOL)focus
{
    // do nothing
    if (focus) {
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.75;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    else {
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;        
    }
}


@end
