
// BSD License. Author: jano at jano.com.es

#import "UTMethod.h"

/** Data for a test case. */
@interface UTClass : NSObject

/** Class to be tested. */
@property (nonatomic,assign) Class clazz;
/** Execution time of this method. */
@property (nonatomic,assign) NSTimeInterval time;
/** Outcome of the method execution. */
@property (nonatomic,assign) BOOL success;
/** Test methods of this class. */
@property (nonatomic,strong) NSArray *methods;

/** 
 * Initialize with the class to test. 
 * @param clazz Class to be tested.
 */
-(id) initWithClass:(Class)clazz;

/** Human readable report with the outcome of the test case execution. */
-(NSString*) report;

@end
