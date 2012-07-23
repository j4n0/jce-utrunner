
// BSD License. Author: jano at jano.com.es

#import "UTCase.h"
#import "DistanceAPIClient.h"

/** Test unit for the DistanceAPIClient class. */
@interface DistanceAPIClientTest : UTCase {
    //int test_disabled;
    dispatch_semaphore_t _semaphore;
}

/** Test drivingTimeBetweenOrigin:destination:success:failure: */
-(void) testDrivingTime;

@end
