//
//  IBXBarButton.m
//  ApplicationBar
//
//  Created by Instbox.com on 4/13/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import "IBXBarButton.h"

#define PADDING 10

@interface IBXBarButton () {
}

@end

@implementation IBXBarButton

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.0);
    CGRect rectangle = CGRectMake(PADDING, PADDING, self.frame.size.width - 2 * PADDING, self.frame.size.height - 2 * PADDING);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, rectangle);
    
    [super drawRect:rect];
}

@end
