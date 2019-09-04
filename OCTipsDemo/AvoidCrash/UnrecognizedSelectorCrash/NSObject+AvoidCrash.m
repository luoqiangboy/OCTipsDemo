
#import "NSObject+AvoidCrash.h"
#import <objc/message.h>
#import "ForwardingTarget.h"
#import "OCCrashAvoidWhiteList.h"
static ForwardingTarget *_target = nil;
@implementation NSObject (AvoidCrash)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _target = [ForwardingTarget new];;
        //交换方法
        classMethodSwizzle([self class], @selector(forwardingTargetForSelector:), @selector(sz_swizzleForwardingTargetForSelector:));
    });
}

+ (BOOL)isWhiteListClass:(Class)class {
    NSString *classString = NSStringFromClass(class);
    BOOL isInternal = [classString hasPrefix:@"_"];
    //处理可变array和dictionary不小心使用copy之后，对对象数据操作时crash的问题。
    if ([classString hasPrefix:@"__NSArray"] || [classString hasPrefix:@"__NSDic"]) {
        return YES;
    }
    //系统内部类不处理。
    if (isInternal) {
        return NO;
    }
    
    //问：为什么要在白名单加NSNull对象？
    //答：因为消息转发给ForwardingTarget之后，动态添加的方法实现IMP是一个返回[NSNull null]对象，外部可能会拿null对象调用方法，依旧会
    //导致crash，所以我们要在白名单设置，然后拦截null进行消息转发
    BOOL isNull =  [classString isEqualToString:NSStringFromClass([NSNull class])];
    
    //这里可以添加需要处理unrecognized selector sent to instance 造成crash的类
    BOOL isMyClass  = NO;
    OCCrashAvoidWhiteList *whiteList = [OCCrashAvoidWhiteList shareInstance];
    if ([whiteList unSelectorWhiteListContainClass:self.class]) {
        isMyClass = YES;
    }
    return isNull || isMyClass;
}

- (id)sz_swizzleForwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%@",NSStringFromSelector(aSelector));
    //如果有其他类自己实现了swizzleForwardingTargetForSelector方法，就使用外部提供的转发对象result
    id result = [self sz_swizzleForwardingTargetForSelector:aSelector];
    if (result) {
        return result;
    }
    //如果不是白名单里面的类，则不处理，返回nil之后crash。
    BOOL isWhiteListClass = [[self class] isWhiteListClass:[self class]];
    if (!isWhiteListClass) {
        return nil;
    }
    //外部没有自己实现swizzleForwardingTargetForSelector以及在白名单里的类，则转发给ForwardingTarget对象
    if (!result) {
        result = _target;
    }
    return result;
}

#pragma mark - private method
//交换方法
BOOL instanceMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSelector);
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzleMethod),
                    method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    return YES;
}

BOOL classMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getClassMethod(aClass, originalSelector);
    Method swizzleMethod = class_getClassMethod(aClass, swizzleSelector);
    method_exchangeImplementations(originalMethod, swizzleMethod);
    return YES;
}
@end
