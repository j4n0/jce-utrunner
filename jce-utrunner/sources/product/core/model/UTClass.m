
// BSD License. Author: jano at jano.com.es

#import "UTClass.h"

@implementation UTClass

-(id) initWithClass:(Class)clazz {
    if (self=[super init]){
        _clazz = clazz;
    }
    return self;
}


-(NSString*) report
{
    NSMutableString *report = [NSMutableString string];
    BOOL success = YES;
    NSMutableString *methodReport = [NSMutableString string];
    for (UTMethod *m in _methods) {
        [methodReport appendFormat:@"  %@",m];
        success = success && m.success;
    }
    [report appendFormat:@"%@",methodReport];
    return report;
}


-(NSUInteger) failures {
    NSUInteger failures=0;
    for (UTMethod *m in _methods) {
        failures += m.success?0:1;
    }
    return failures;
}


-(NSString*) description {
    // prints something like "SomeTest 3/3"
    return [NSString stringWithFormat:@"%@ %d/%d", NSStringFromClass(_clazz), [_methods count]-[self failures], [_methods count]];
}

@end
