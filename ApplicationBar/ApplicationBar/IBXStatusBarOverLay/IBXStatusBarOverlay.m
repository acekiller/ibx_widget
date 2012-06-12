//
//  IBXStatusBarOverlay.m
//  ApplicationBar
//
//  Created by 剑锋 屠 on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXStatusBarOverlay.h"

@implementation IBXStatusBarOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        self.windowLevel = UIWindowLevelStatusBar+1.f;
        self.frame = statusBarFrame;
		self.alpha = 0.f;
		self.hidden = NO;
    }
    return self;
}


+ (IBXStatusBarOverlay *)sharedInstance {
    static dispatch_once_t pred;
    __strong static IBXStatusBarOverlay *sharedOverlay = nil; 
    
    dispatch_once(&pred, ^{ 
        sharedOverlay = [[IBXStatusBarOverlay alloc] init]; 
    }); 
    
	return sharedOverlay;
}

+ (IBXStatusBarOverlay *)sharedOverlay {
	return [self sharedInstance];
}

#pragma mark - public

- (void)showMessage:(NSString *)message
{
    
}

@end
