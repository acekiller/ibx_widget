//
//  IBXToast.m
//  ApplicationBar
//
//  Created by Instbox.com on 4/17/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import "IBXToast.h"

#define DEFAULT_DELAY_SECONDS 3

@interface IBXToast ()
{
    UILabel * _contentLabel;
    UIButton * _hideButton;
    UIButton * _cancelButton;
    
    void (^_cancelBlock)();
    NSString * _canceledMessage;
}

@end

@implementation IBXToast

@synthesize contentLabel = _contentLabel;

- (void)dealloc
{
    [_contentLabel release];
    [_hideButton release];
    [_cancelButton release];
    
    [_cancelBlock release];
    [_canceledMessage release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = UITextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_contentLabel];
        
        _hideButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_hideButton addTarget:self 
                        action:@selector(hideSelf) 
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_hideButton];
        [self bringSubviewToFront:_hideButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentLabel.frame = CGRectMake(0, 0, self.frame.size.width, 70);
    _contentLabel.center = self.center;
    _hideButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _cancelButton.frame = CGRectMake(self.frame.size.width - 100, CGRectGetMaxY(_contentLabel.frame), 100, 50);
}

- (void)hideSelf
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                             selector:@selector(hideSelf) 
                                               object:nil];
    
    [UIView animateWithDuration:0.2 
                     animations:^{
        CGRect frame = self.frame;
        frame.origin.x += frame.size.width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - self

- (void)cancelButtonClicked:(id)sender
{
    if (_cancelBlock != nil) {
        _cancelBlock();
        
        [_cancelBlock release];
        _cancelBlock = nil;
        _contentLabel.text = _canceledMessage;
        _cancelButton.hidden = YES;
    }
}

#pragma mark - public

- (void)showMessage:(NSString *)message
{
    [self showMessage:message 
             autoHide:YES 
                delay:DEFAULT_DELAY_SECONDS];
}

- (void)showMessage:(NSString *)message 
           autoHide:(BOOL)autoHide 
              delay:(CGFloat)seconds
{
    [self removeFromSuperview];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    CGRect frame = window.frame;
    frame.origin.x = -window.frame.size.width;
    self.frame = frame;
    [window addSubview:self];
    
    self.contentLabel.text = message;
    [self setNeedsLayout];

    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.x = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (autoHide) {
            [self performSelector:@selector(hideSelf)
                       withObject:nil 
                       afterDelay:seconds];
        }
    }];
}

- (void)setCancelButton:(NSString *)cancelTitle
            cancelBlock:(void (^)(void))cancelBlock
        canceledMessage:(NSString *)message
{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _cancelButton.frame = CGRectMake(0, 0, 50, 50);
        _cancelButton.backgroundColor = [UIColor grayColor];
        [_cancelButton addTarget:self 
                          action:@selector(cancelButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    
    [_cancelBlock release];
    _cancelBlock = [cancelBlock retain];
    
    [_canceledMessage release];
    _canceledMessage = [message copy];
}

@end
