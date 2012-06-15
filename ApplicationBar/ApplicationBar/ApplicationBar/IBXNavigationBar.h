//
//  IBXNavigationBar.h
//  ApplicationBar
//
//  Created by Instbox.com on 4/12/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NAVIGATION_BAR_BUTTON_LEFT,
    NAVIGATION_BAR_BUTTON_RIGHT,
    NAVIGATION_BAR_BUTTON_TITLE,
} NavigationBarButtonType;

@protocol IBXNavigationBarDelegate <NSObject>

@required
- (void)navigationBarButtonClicked:(NavigationBarButtonType)type;

@end

@interface IBXNavigationBar : UIView

@property (nonatomic, readonly) UILabel * titleLabel;
@property (nonatomic, assign) id<IBXNavigationBarDelegate> navigationBarDelegate;

- (void)setButton:(NSString *)title 
       buttonType:(NavigationBarButtonType)type;
- (void)setButtonIcon:(UIImage *)image
           buttonType:(NavigationBarButtonType)type;

@end
