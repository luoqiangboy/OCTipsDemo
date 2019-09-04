
#import "NSTimerProxy.h"
#import "ForwardingTarget.h"

@interface NSTimerProxy ()
@property (nonatomic, strong) ForwardingTarget *forwordingTarget;
@end

@implementation NSTimerProxy

- (instancetype)init
{
    self = [super init];
    if (self) {
        _forwordingTarget = [[ForwardingTarget alloc] init];
    }
    return self;
}

//消息转发到这个类的时候，首先会调用resolveInstanceMethod方法
- (id)forwardingTargetForSelector:(SEL)aSelector {
    //回调对象存在，则用转发给回调对象
    if (self.target) {
       return self.target;
    }
    //回调对象不存在了，关闭定时器，避免内存泄漏
    [self.timer invalidate];
    self.timer = nil;
    //转发给ForwardingTarget对象，处理unrecognized selector sent to instance
    return _forwordingTarget;
}

- (void)dealloc {
    NSLog(@"%@  %@",NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}
@end
