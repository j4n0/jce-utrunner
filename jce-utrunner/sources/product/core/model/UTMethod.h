
// BSD License. Author: jano at jano.com.es

#import <objc/runtime.h>

/** Method to test. */
@interface UTMethod : NSObject

/** Class this method belongs to. */
@property (nonatomic,assign) Class clazz;
/** Method to test. */
@property (nonatomic,assign) Method method;
/** Outcome of the method execution. */
@property (nonatomic,assign) BOOL success;
/** Time it took to execute the method, or 0 if it wasn't ever ran. */
@property (nonatomic,assign) NSTimeInterval time;
/** Error detail (if any) with the outcome of the method execution. */
@property (nonatomic,copy) NSString *errorDetail;

/** 
 * Initialize with the given method and class. 
 * @param method Method to execute.
 * @param clazz Class the method belongs to.
 */
-(id) initWithMethod:(Method)method fromClass:(Class)clazz;
    
@end
