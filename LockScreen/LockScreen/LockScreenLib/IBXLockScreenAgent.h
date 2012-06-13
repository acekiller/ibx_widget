//
//  IBXLockScreenAgent.h
//  LockScreen
//
//  Created by 剑锋 屠 on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBXLockScreenAgent : NSObject

+ (void)savePassword:(NSString *)password;
+ (void)clearPassword;
+ (BOOL)checkPassword:(NSString *)password;
+ (BOOL)isSaved;

@end
