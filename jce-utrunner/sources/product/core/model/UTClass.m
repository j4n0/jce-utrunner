
// BSD License. Author: jano at jano.com.es

#import "UTClass.h"

@implementation UTClass

@synthesize clazz=_clazz, methods=_methods, time=_time, success=_success;

-(id) initWithClass:(Class)clazz {
    if (self=[super init]){
        _clazz = clazz;
    }
    return self;
}


-(NSString*) report 
{
    NSMutableString *report = [NSMutableString string];
    [report appendString:[self description]];
    BOOL success = YES;
    NSMutableString *methodReport = [NSMutableString string];
    for (UTMethod *m in _methods) {
        [methodReport appendFormat:@"\n  %@",m];
        success = success && m.success;
    }
    [report appendFormat:@"%@",methodReport];
    return report;
}


-(NSString*) description {
    int failures=0;
    for (UTMethod *m in _methods) {
        failures += m.success?:1;
    }
    // prints something like "SomeTest 3/3" with one line break before and after
    return [NSString stringWithFormat:@"\n%@ %d/%d\n", NSStringFromClass(_clazz), failures, [_methods count]];
}

@end
