//
//  OCCrashAvoidWhiteList.m
//  OCTipsDemo
//
//  Created by luoqiang on 2019/9/4.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "OCCrashAvoidWhiteList.h"

@implementation OCCrashAvoidWhiteList

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static OCCrashAvoidWhiteList *whiteList = nil;
    dispatch_once(&onceToken, ^{
        whiteList = [[OCCrashAvoidWhiteList alloc] init];
    });
    return whiteList;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timerWhiteList = @[].mutableCopy;
        _kvoWhiteList = @[].mutableCopy;
        _unSelectorWhiteList = @[].mutableCopy;
    }
    return self;
}

- (void)userInAllCrashWithWhiteLists:(NSArray *)whiteLists {
    [self userInKVOCrashWithWhiteLists:whiteLists];
    [self userInTimerCrashWithWhiteLists:whiteLists];
    [self userInunSelectorCrashWithWhiteLists:whiteLists];
}

- (void)userInKVOCrashWithWhiteLists:(NSArray *)whiteLists {
    [_kvoWhiteList addObjectsFromArray:whiteLists];
}

- (void)userInTimerCrashWithWhiteLists:(NSArray *)whiteLists {
    [_timerWhiteList addObjectsFromArray:whiteLists];
}

- (void)userInunSelectorCrashWithWhiteLists:(NSArray *)whiteLists {
    [_unSelectorWhiteList addObjectsFromArray:whiteLists];
}

- (BOOL)timerWhiteListContainClass:(Class)cls {
    NSString *clsString = NSStringFromClass(cls);
    for (NSString *clsStr in _timerWhiteList) {
        if ([clsStr isEqualToString:clsString]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)KVOWhiteListContainClass:(Class)cls {
    NSString *clsString = NSStringFromClass(cls);
    for (NSString *clsStr in _kvoWhiteList) {
        if ([clsStr isEqualToString:clsString]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)unSelectorWhiteListContainClass:(Class)cls {
    NSString *clsString = NSStringFromClass(cls);
    for (NSString *clsStr in _unSelectorWhiteList) {
        if ([clsStr isEqualToString:clsString]) {
            return YES;
        }
    }
    return NO;
}

@end
