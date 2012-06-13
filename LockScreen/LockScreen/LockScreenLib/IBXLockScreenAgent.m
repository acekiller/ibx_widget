//
//  IBXLockScreenAgent.m
//  LockScreen
//
//  Created by 剑锋 屠 on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXLockScreenAgent.h"

#define KEY_SAVED_PASSWORD @"key_saved_password"

@implementation IBXLockScreenAgent

+ (void)savePassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_SAVED_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_SAVED_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)checkPassword:(NSString *)password
{
    NSString * string = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_SAVED_PASSWORD];
    return [password isEqualToString:string];
}

+ (BOOL)isSaved
{
    NSString * string = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_SAVED_PASSWORD];
    return [string length] > 0;
}

@end
