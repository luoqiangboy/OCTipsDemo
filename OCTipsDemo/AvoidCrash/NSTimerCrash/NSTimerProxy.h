
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimerProxy : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, weak) NSTimer *timer;
@end

NS_ASSUME_NONNULL_END
