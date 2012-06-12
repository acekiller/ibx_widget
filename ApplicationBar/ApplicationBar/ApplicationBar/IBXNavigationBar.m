//
//  IBXNavigationBar.m
//  ApplicationBar
//
//  Created by Instbox.com on 4/12/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import "IBXNavigationBar.h"
#import "IBXBarButton.h"

#define IBX_NAVIGATION_BAR_DEFAULT_WIDTH  320
#define IBX_NAVIGATION_BAR_DEFAULT_HEIGHT 44
#define DEFAULT_PADDING 10
#define MIN_BUTTON_WIDTH 65

@interface IBXNavigationBar ()
{
    UILabel * _titleLabel;
    UIButton * _rightButton;
    UIButton * _leftButton;
    UIButton * _titleButton;
    
    id<IBXNavigationBarDelegate> _navigationBardelegate;
}

@end

@implementation IBXNavigationBar

@synthesize titleLabel = _titleLabel;
@synthesize navigationBarDelegate = _navigationBardelegate;

- (void)dealloc
{
    [_titleLabel release];
    [_rightButton release];
    [_leftButton release];
    [_titleButton release];
    
    _navigationBardelegate = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 0, self.frame.size.width / 2., self.frame.size.height);
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.center = self.center;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _titleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_titleButton addTarget:self 
                         action:@selector(navigationBarButtonClicked:) 
               forControlEvents:UIControlEventTouchUpInside];
        _titleButton.frame = _titleLabel.frame;
        [self addSubview:_titleButton];
    }
    
    return _titleLabel;
}

- (UIButton *)allocBarButton
{
    IBXBarButton * button = [[IBXBarButton buttonWithType:UIButtonTypeCustom] retain];
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigationBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setButton:(NSString *)title 
       buttonType:(NavigationBarButtonType)type
{
    if (type == NAVIGATION_BAR_BUTTON_LEFT) {
        if (_leftButton == nil) {
            _leftButton = [self allocBarButton];
            [self addSubview:_leftButton];
        }
        
        [_leftButton setTitle:title forState:UIControlStateNormal];
        [_leftButton sizeToFit];
        
        _leftButton.frame = CGRectMake(0,
                                       0,
                                       _leftButton.frame.size.width + 3 * DEFAULT_PADDING,
                                       self.frame.size.height);
    }
    else if (type == NAVIGATION_BAR_BUTTON_RIGHT) {
        if (_rightButton == nil) {
            _rightButton = [self allocBarButton];
            [self addSubview:_rightButton];
        }
        
        [_rightButton setTitle:title forState:UIControlStateNormal];
        [_rightButton sizeToFit];
        
        CGFloat width = _rightButton.frame.size.width + 3 * DEFAULT_PADDING;
        _rightButton.frame = CGRectMake(self.frame.size.width - width, 
                                        0, 
                                        width,
                                        self.frame.size.height);
    }
}

- (void)navigationBarButtonClicked:(id)sender
{    
    if (_navigationBardelegate && [_navigationBardelegate respondsToSelector:@selector(navigationBarButtonClicked:)]) {
        if (sender == _rightButton) {
            [_navigationBardelegate navigationBarButtonClicked:NAVIGATION_BAR_BUTTON_RIGHT];
        }
        else if (sender == _leftButton) {
            [_navigationBardelegate navigationBarButtonClicked:NAVIGATION_BAR_BUTTON_LEFT];
        }
        else if (sender == _titleButton) {
            [_navigationBardelegate navigationBarButtonClicked:NAVIGATION_BAR_BUTTON_TITLE];
        }
    }
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    CGRect frame = self.frame;
    frame.size.width = IBX_NAVIGATION_BAR_DEFAULT_WIDTH;
    frame.size.height = IBX_NAVIGATION_BAR_DEFAULT_HEIGHT;
    self.frame = frame;
}


@end
