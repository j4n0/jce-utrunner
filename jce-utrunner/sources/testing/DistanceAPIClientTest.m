
// BSD License. Author: jano at jano.com.es

#import "DistanceAPIClientTest.h"

@implementation DistanceAPIClientTest


-(void) testDrivingTime {
    
    // blocks with semaphore
    _semaphore = dispatch_semaphore_create(0); 
    
    AFJSONSuccess success = ^(NSURLRequest *request, NSHTTPURLResponse *response, id json){
        debug(@"SUCCESS class=%@, value=%@", [json class], json);
        dispatch_semaphore_signal(_semaphore);
    };
    AFJSONFailure failure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        debug(@"FAILURE error=%@", [error localizedDescription]);
        dispatch_semaphore_signal(_semaphore);
        UTAssertTrue(false, @"Login failed.");
    };   
    
    // For coordinates, go to http://itouchmap.com/latlong.html
    NSString *origin = @"Puerta del Sol, Madrid"; // @"40.417009,-3.703482"
    NSString *destination = @"Cuzco, Madrid"; // 40.458426,-3.689855
    
    // API call
    DistanceAPIClient *client = [DistanceAPIClient new];
    [client drivingTimeBetweenOrigin:origin destination:destination success:success failure:failure];
    
    // wait at most 10 seconds
    NSDate *tenSeconds = [NSDate dateWithTimeIntervalSinceNow:10];
    
    // DISPATCH_TIME_NOW = don't wait for the semaphore in case it is unavailable
    // dispatch_semaphore_wait returns zero (false) on success, or non-zero (true) if the timeout occurred.
    while ( [[NSDate date] timeIntervalSinceDate:tenSeconds]<0
            && dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_NOW)){
        // Runs the loop once, blocking for input in the specified mode until .2 secs
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode 
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:.2]];
    }
    
    // fail if later than 10 seconds
    BOOL onTime = [[NSDate date] timeIntervalSinceDate:tenSeconds]<0;
    UTAssertTrue(onTime, @"Too late.");
    
    // clean up
    dispatch_release(_semaphore);
}

@end
