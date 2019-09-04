
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOProxy : NSObject
@property (nonatomic, weak) id target;//被监听对象
@property (nonatomic, weak) id observer;//监听对象
@property (nonatomic, copy) NSString *keyPath;//监听属性

@end

NS_ASSUME_NONNULL_END
