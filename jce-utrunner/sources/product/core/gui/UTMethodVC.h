
// BSD License. Author: jano at jano.com.es

#import "UTRunner.h"
#import <objc/runtime.h>

/** Controller to test a particular method. */
@interface UTMethodVC  : UIViewController

/** The method to test. This is set from the previous controller. */
@property (nonatomic, strong) UTMethod *utMethod;

@end
