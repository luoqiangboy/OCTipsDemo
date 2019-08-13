//
//  AppDelegate+OC.h
//  OCTipsDemo
//
//  Created by luoqiang on 2019/8/13.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (OC)

- (void)registerAPN;
- (void)addLocalNotice;
- (void)removeOneNotificationWithID:(NSString *)noticeId;

@end

NS_ASSUME_NONNULL_END
