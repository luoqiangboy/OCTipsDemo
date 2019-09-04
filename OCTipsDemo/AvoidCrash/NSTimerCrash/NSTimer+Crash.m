

#import "NSTimer+Crash.h"
#import "NSObject+AvoidCrash.h"
#import "NSTimerProxy.h"
#import "OCCrashAvoidWhiteList.h"

@implementation NSTimer (Crash)
+ (void)load {
    classMethodSwizzle(self, @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(sz_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
}

+ (NSTimer *)sz_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    //定时器白名单
    OCCrashAvoidWhiteList *whiteList = [OCCrashAvoidWhiteList shareInstance];
    if (![whiteList timerWhiteListContainClass:self.class]) {
        return [self sz_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    }
    
    NSTimerProxy *proxy = [NSTimerProxy new];
    //proxy堆target弱引用，防止timer与target循环引用。
    proxy.target = aTarget;
    //弱引用timer，为的是在target在dealloc之后，自动销毁定时器tiemr
    proxy.timer = [self sz_scheduledTimerWithTimeInterval:ti target:proxy selector:aSelector userInfo:userInfo repeats:yesOrNo];
    return proxy.timer;
}
@end
