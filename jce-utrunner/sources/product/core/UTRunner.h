
// BSD License. Author: jano at jano.com.es

#import <objc/runtime.h>
#import "UTCase.h"
#import "UTClass.h"
#import "UTMethod.h"
#import "UTDelegate.h"

/** Returns true/false for the given class. */
typedef bool(^ClassFilterBlock)(Class);

/** Returns true/false for the given method. */
typedef bool(^MethodFilterBlock)(Method);


/** Test case runner. */
@interface UTRunner : NSObject

@property (nonatomic,strong) id <UTDelegate> delegate;

/** Test cases. */
@property (nonatomic,strong) NSMutableArray *testCases;

/** Return the test cases as UTClass objects. */
-(NSMutableArray*) testCasesWithClassFilter:(ClassFilterBlock)classFilter 
                               methodFilter:(MethodFilterBlock)methodFilter;

/** 
 * Run the tests on this class.
 * This creates an instance, calls setupClass, runInstance, and teardownClass.
 * @param utClass Class to test.
 */
-(void) runClass:(UTClass*)utClass;

/** Runs all test cases. */
-(void) runAllClasses;

/** Prints to console the result of testing all test cases. */
-(void) printReport;

/** 
 * Runs the given method creating an instance of its class first. 
 * @param utMethod Method to test.
 */
-(void) runMethod:(UTMethod*)utMethod;

@end
