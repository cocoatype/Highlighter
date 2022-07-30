// InstanceHelper is from https://qualitycoding.org/unit-test-scene-delegates/

#import <Foundation/Foundation.h>

@interface InstanceHelper : NSObject
+ (id)createInstance:(Class)clazz;
+ (id)createInstance:(Class)clazz properties:(NSDictionary *)properties;
@end
