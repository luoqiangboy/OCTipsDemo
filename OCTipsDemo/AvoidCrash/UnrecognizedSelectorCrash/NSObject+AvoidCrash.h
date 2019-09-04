

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AvoidCrash)
BOOL instanceMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector);
BOOL classMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector);
@end

NS_ASSUME_NONNULL_END
