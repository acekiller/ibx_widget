//
//  IBXLockScreenViewController.h
//  LockScreen
//
//  Created by 剑锋 屠 on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TYPE_CANCEL_SET,
    TYPE_NORMAL_PASS,
} HideResultType;

@protocol IBXLockScreenDelegate <NSObject>

- (void)hideWithResult:(HideResultType)type;

@end

@interface IBXLockScreenView : UIView <UITextViewDelegate>

@property (nonatomic, assign) id<IBXLockScreenDelegate> delegate;

+ (IBXLockScreenView *)getView:(CGRect)frame;

@end
