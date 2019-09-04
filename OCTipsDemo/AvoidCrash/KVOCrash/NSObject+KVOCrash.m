

#import "NSObject+KVOCrash.h"
#import <objc/message.h>
#import "NSObject+AvoidCrash.h"
#import "KVOProxy.h"
#import "SZCrashAvoidWhiteList.h"

static NSString *kmObserversIdentify = @"kmObserversIdentify";

@interface NSObject ()
@property (atomic, strong) NSHashTable *mObservers;
@end

@implementation NSObject (KVOCrash)
+ (void)load {
    
    instanceMethodSwizzle(self, @selector(addObserver:forKeyPath:options:context:), @selector(sz_addObserver:forKeyPath:options:context:));
    instanceMethodSwizzle(self, @selector(removeObserver:forKeyPath:), @selector(sz_removeObserver:forKeyPath:));
}

- (void)sz_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
   
    SZCrashAvoidWhiteList *whiteList = [SZCrashAvoidWhiteList shareInstance];
    if (![whiteList KVOWhiteListContainClass:self.class]) {
        return;
    }
    @try {
        //写错keypath的时候，valueForKey会crash，使用try_catch可以避免崩溃
        [self valueForKey:keyPath];
    } @catch (NSException *exception) {
        NSLog(@"没有该keypath：%@",[NSString stringWithFormat:@"%@",keyPath]);
        return;
    } @finally {
        
    }
    
    //如果没有崩溃则继续走
    if (observer && keyPath.length > 0 && keyPath != nil) {
        //避免重复添加
        if (![self hasSameObserversKeyPath:keyPath observer:observer]) {
            @synchronized (self) {
                KVOProxy *kvoProxy = [KVOProxy new];
                kvoProxy.target = self;
                kvoProxy.observer = observer;
                kvoProxy.keyPath = keyPath;
                [self.mObservers addObject:kvoProxy];
                NSLog(@"add :%@",self.mObservers.allObjects);
                [kvoProxy.target sz_addObserver:kvoProxy forKeyPath:kvoProxy.keyPath options:options context:context];
            }
        }
    }
}

- (void)sz_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    SZCrashAvoidWhiteList *whiteList = [SZCrashAvoidWhiteList shareInstance];
    if (![whiteList KVOWhiteListContainClass:self.class]) {
        return;
    }
    if (observer) {
        //移除已经添加过的监听。避免写错keypath导致crash
        KVOProxy *kvoProxy = [self hasSameObserversKeyPath:keyPath observer:observer];
        if (kvoProxy) {
            @synchronized (self) {
              [self.mObservers removeObject:kvoProxy];
            }
            [kvoProxy.target sz_removeObserver:kvoProxy forKeyPath:kvoProxy.keyPath];
        }
    }
}

- (KVOProxy *)hasSameObserversKeyPath:(NSString *)keyPath observer:(id)observer {
    KVOProxy *kvoProxy = nil;
    NSHashTable *table = self.mObservers;
    NSLog(@"same : %@",table.allObjects);
    for (KVOProxy *kvoProxy_ in [self.mObservers allObjects]) {
        //添加同一个监听，这个条件会成立：observer == kvoProxy_.observer
        //由于监听的时候，实际上监听的是kvoProxy_，当observer已经dealloc之后，observer == kvoProxy_.observer条件已经不成立，所以使用条件observer == kvoProxy_
        if ([kvoProxy_.keyPath isEqualToString:keyPath] && (observer == kvoProxy_.observer || observer == kvoProxy_)) {
            kvoProxy = kvoProxy_;
            break;
        }
    }
    return kvoProxy;
}

#pragma 实现mObservers的声明
- (void)setMObservers:(NSHashTable *)mObservers {
    objc_setAssociatedObject(self, &kmObserversIdentify, mObservers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSHashTable *)mObservers {
    NSHashTable *mObservers_ = objc_getAssociatedObject(self, &kmObserversIdentify);
    if (!mObservers_) {
        mObservers_ = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsStrongMemory capacity:5];
        objc_setAssociatedObject(self, &kmObserversIdentify, mObservers_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mObservers_;
}
@end
