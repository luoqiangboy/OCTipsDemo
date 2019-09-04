

#import "KVOProxy.h"
#import "ForwardingTarget.h"
#import <objc/message.h>

@interface KVOProxy ()
@property (nonatomic, strong) ForwardingTarget *forwordingTarget;
@end

@implementation KVOProxy

- (instancetype)init
{
    self = [super init];
    if (self) {
        _forwordingTarget = [[ForwardingTarget alloc] init];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.observer) {
        [self.target removeObserver:self forKeyPath:keyPath];
        return;
    }
    ((void (*) (id, SEL, id ,id ,id, (void *)))(void *) objc_msgSend)(self.observer, @selector(observeValueForKeyPath:ofObject:change:context:),keyPath,object,change,context);
}

- (void)dealloc {
    NSLog(@"%@  %@",NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}
@end
