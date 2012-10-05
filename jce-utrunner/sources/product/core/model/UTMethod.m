
// BSD License. Author: jano at jano.com.es

#import "UTMethod.h"

@implementation UTMethod

@synthesize clazz   = _clazz;
@synthesize method  = _method;
@synthesize success = _success;
@synthesize time    = _time;
@synthesize errorDetail = _errorDetail;

-(id) initWithMethod:(Method)method fromClass:(Class)clazz {
    if (self=[super init]){
        _method = method;
        _clazz = clazz;
        _errorDetail = nil;
    }
    return self;
}

/** 
 * OK 0.00026 someMethod 
 * SomeException: something went awry.
 */
-(NSString*) description {
    NSMutableString *diz = [NSMutableString string];
    [diz appendFormat:@"%@ %f ", _success ? @"   OK":@"  BAD", _time];
    [diz appendString:NSStringFromSelector(method_getName(_method))];
    [diz appendString:@"\n"];
    if (_errorDetail!=nil) [diz appendFormat:@"\n      %@",_errorDetail];
    return diz;
}

@end
