
// BSD License. Author: jano at jano.com.es

/** Returns a string formatted with variadic arguments. */
NSString *stringWithArguments(NSString *description, ...);

/** Test expression. */
#define UTAssertTrue(expr, failReason, ...) \
if (!expr) { \
    NSMutableDictionary *info = [NSMutableDictionary dictionary]; \
    [info setValue:[NSString stringWithUTF8String:__FILE__] forKey:@"file"]; \
    [info setValue:[NSNumber numberWithInt:__LINE__] forKey:@"line"]; \
    NSException *exception = [NSException exceptionWithName:@"UTAssertTrueException" \
                                                     reason:stringWithArguments(failReason, ##__VA_ARGS__) \
                                                   userInfo:info]; \
    @throw exception; \
}

#import <objc/runtime.h>


/** Superclass of all test cases. */
@interface UTCase : NSObject

@property (nonatomic,assign) bool finished;

-(void) runBlock:(void(^)(void))block timeLimit:(NSTimeInterval)expiration notification:(NSString*)notification;

/** Called before testing the class. */
-(void) setupClass;
/** Called after testing the class. */
-(void) teardownClass;

/** Called before testing the class. */
-(void) setupMethod;
/** Called after testing the class. */
-(void) teardownMethod;

-(void) handleNotification:(NSNotification*)notification;

@end
