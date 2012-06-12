//
//  IBXToast.h
//  ApplicationBar
//
//  Created by Instbox.com on 4/17/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBXToast : UIView


@property (nonatomic, readonly) UILabel * contentLabel;

- (void)hideSelf;
- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message 
           autoHide:(BOOL)autoHide 
              delay:(CGFloat)seconds;
- (void)setCancelButton:(NSString *)cancelTitle
            cancelBlock:(void (^)(void))cancelBlock
        canceledMessage:(NSString *)message;

@end
