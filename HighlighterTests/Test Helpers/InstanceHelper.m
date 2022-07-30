#import "InstanceHelper.h"

@implementation InstanceHelper
+ (id)createInstance:(Class)clazz {
    return [[clazz alloc] init];
}

+ (id)createInstance:(Class)clazz properties:(NSDictionary *)properties {
    id object = [self createInstance:clazz];
    if ([object isKindOfClass:[NSObject class]]) {
        NSObject *nsObject = object;
        [properties enumerateKeysAndObjectsUsingBlock:^(id key, id valueObject, BOOL *stop) {
            [nsObject setValue:valueObject forKey:key];
        }];
    }
    return object;
}
@end
