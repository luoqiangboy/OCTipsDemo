

#import "ForwardingTarget.h"
#import "objc/message.h"
@implementation ForwardingTarget
id forwardingTarget_dynamicMethod(id self, SEL _cmd) {
    return [NSNull null];
}

//消息转发到这个类的时候，首先会调用resolveInstanceMethod方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod(self.class, sel, (IMP)forwardingTarget_dynamicMethod, "@@:");
    [super resolveInstanceMethod:sel];
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id result = [super forwardingTargetForSelector:aSelector];
    return result;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    id result = [super methodSignatureForSelector:aSelector];
    return result;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [super forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector]; // crash
}
@end
