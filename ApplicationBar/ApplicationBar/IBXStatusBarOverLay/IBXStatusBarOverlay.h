//
//  IBXStatusBarOverlay.h
//  ApplicationBar
//
//  Created by 剑锋 屠 on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBXStatusBarOverlay : UIWindow

+ (IBXStatusBarOverlay *)sharedInstance;
+ (IBXStatusBarOverlay *)sharedOverlay;

- (void)showMessage:(NSString *)message;

@end
