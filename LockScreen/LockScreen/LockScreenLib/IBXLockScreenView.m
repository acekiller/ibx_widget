//
//  IBXLockScreenViewController.m
//  LockScreen
//
//  Created by 剑锋 屠 on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXLockScreenView.h"
#import "IBXLockScreenAgent.h"

#define NUMBER_LABEL_WIDTH       50
#define NUMBER_LABEL_PADDING_TOP 90
#define TIP_LABEL_PADDING_TOP    30
#define TIP_LABEL_PADDIN         30
#define TIP_LABEL_HEIGHT         30

@interface IBXLockScreenView ()
{
    UITextView * hiddenTextView;
    UILabel * label1, * label2, * label3, * label4;
    UILabel * tipLabel;
    UIButton * cancelButton;
    NSString * tempString;
    
    id<IBXLockScreenDelegate> _delegate;
}

@end

@implementation IBXLockScreenView

@synthesize delegate = _delegate;

- (void)dealloc
{
    [hiddenTextView release];
    [label1 release];
    [label2 release];
    [label3 release];
    [label4 release];
    [tipLabel release];
    [cancelButton release];
    [tempString release];
    
    [super dealloc];
}

#pragma mark - Singleton

+ (IBXLockScreenView *)getView:(CGRect)frame
{
    static IBXLockScreenView * view;
    if (view == nil) {
        view = [[IBXLockScreenView alloc] init];
        view.frame = frame;
        [view initUI];
    }
    view.frame = frame;
    [view refreshUI];
    
    return view;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] > 4) textView.text = [textView.text substringWithRange:NSMakeRange(0, 4)];
    [self updateLabels:textView.text];
}

#pragma mark - check

- (void)clearNumber
{
    hiddenTextView.text = @"";
    [self updateLabels:@""];
}

- (void)updateLabels:(NSString *)str
{
    if ([str length] > 0) label1.text = [str substringWithRange:NSMakeRange(0, 1)];
    else label1.text = @"";
    if ([str length] > 1) label2.text = [str substringWithRange:NSMakeRange(1, 1)];
    else label2.text = @"";
    if ([str length] > 2) label3.text = [str substringWithRange:NSMakeRange(2, 1)];
    else label3.text = @"";
    
    if ([str length] > 3) {
        label4.text = [str substringWithRange:NSMakeRange(3, 1)];
        
        [self performSelector:@selector(checkNumber:) withObject:str afterDelay:0.5];        
    }
    else label4.text = @"";
}

- (void)checkNumber:(NSString *)str
{
    NSString * stringToUse = [str substringWithRange:NSMakeRange(0, 4)];
    
    if (![IBXLockScreenAgent isSaved]) {
        if ([tempString length] > 0) {
            if ([tempString isEqualToString:str]) {
                [IBXLockScreenAgent savePassword:str];
                [tempString release];
                tempString = nil;
                [self hideSelf];
            }
            else {
                [tempString release];
                tempString = nil;
                tipLabel.text = @"Input password";
            }
        }
        else {
            [tempString release];
            tempString = [stringToUse copy];
            tipLabel.text = @"Reinput password";
        }
    }
    else if ([IBXLockScreenAgent checkPassword:str]) {
        [self hideSelf];
    }
    else {
        tipLabel.text = @"Error, reinput password";
    }
    [self clearNumber];
}

- (void)hideSelf
{
    [self removeFromSuperview];
    [self clearNumber];
}

- (void)cancelSetting
{
    if ([_delegate respondsToSelector:@selector(hideWithResult:)]) {
        [_delegate hideWithResult:TYPE_CANCEL_SET];
    }
    
    [self hideSelf];
}

#pragma mark - UIView

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    if (hiddenTextView == nil) {
        hiddenTextView = [[UITextView alloc] init];
        hiddenTextView.keyboardType = UIKeyboardTypeNumberPad;
        hiddenTextView.delegate = self;
        
        [self addSubview:hiddenTextView];
    }
    
    if (label1 == nil) {
        label1 = [[UILabel alloc] init];
        label2 = [[UILabel alloc] init];
        label3 = [[UILabel alloc] init];
        label4 = [[UILabel alloc] init];
        CGFloat padding = (self.frame.size.width - 4 * NUMBER_LABEL_WIDTH) / 5.f;
        label1.frame = CGRectMake(padding, NUMBER_LABEL_PADDING_TOP, NUMBER_LABEL_WIDTH, NUMBER_LABEL_WIDTH);
        label2.frame = CGRectMake(padding + NUMBER_LABEL_WIDTH + padding, NUMBER_LABEL_PADDING_TOP, NUMBER_LABEL_WIDTH, NUMBER_LABEL_WIDTH);
        label3.frame = CGRectMake(padding + (NUMBER_LABEL_WIDTH + padding) * 2, NUMBER_LABEL_PADDING_TOP, NUMBER_LABEL_WIDTH, NUMBER_LABEL_WIDTH);
        label4.frame = CGRectMake(padding + (NUMBER_LABEL_WIDTH + padding) * 3, NUMBER_LABEL_PADDING_TOP, NUMBER_LABEL_WIDTH, NUMBER_LABEL_WIDTH);
        label1.backgroundColor = [UIColor lightGrayColor];
        label2.backgroundColor = [UIColor lightGrayColor];
        label3.backgroundColor = [UIColor lightGrayColor];
        label4.backgroundColor = [UIColor lightGrayColor];
        label1.textAlignment = UITextAlignmentCenter;
        label2.textAlignment = UITextAlignmentCenter;
        label3.textAlignment = UITextAlignmentCenter;
        label4.textAlignment = UITextAlignmentCenter;
        label1.font = [UIFont boldSystemFontOfSize:24];
        label2.font = [UIFont boldSystemFontOfSize:24];
        label3.font = [UIFont boldSystemFontOfSize:24];
        label4.font = [UIFont boldSystemFontOfSize:24];
        label1.textColor = [UIColor whiteColor];
        label2.textColor = [UIColor whiteColor];
        label3.textColor = [UIColor whiteColor];
        label4.textColor = [UIColor whiteColor];
        [self addSubview:label1];
        [self addSubview:label2];
        [self addSubview:label3];
        [self addSubview:label4];
    }
    
    if (tipLabel == nil) {
        tipLabel = [[UILabel alloc] init];
        tipLabel.frame = CGRectMake(TIP_LABEL_PADDIN, TIP_LABEL_PADDING_TOP, self.frame.size.width - 2 * TIP_LABEL_PADDIN, TIP_LABEL_PADDIN);
        tipLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:tipLabel];
    }
    
    if (cancelButton == nil) {
        cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [cancelButton setTitle:@"X" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        CGFloat width = 50;
        cancelButton.frame = CGRectMake(self.frame.size.width - width, 0, width, width);
        [cancelButton addTarget:self action:@selector(cancelSetting) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    
}

- (void)refreshUI
{
    cancelButton.hidden = ([IBXLockScreenAgent isSaved]);
    tipLabel.text = @"Input password";
    [hiddenTextView becomeFirstResponder];
    
}

@end
