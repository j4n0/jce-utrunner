
// BSD License. Author: jano at jano.com.es

#import "AFJSONRequestOperation.h"

/** Block type for the success case of the AFJSONRequestOperation. */
typedef void (^AFJSONSuccess)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
/** Block type for the failure case of the AFJSONRequestOperation. */
typedef void (^AFJSONFailure)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);

// distance api url and parameter keys
#define kDAPI_URL           @"http://maps.googleapis.com/maps/api/distancematrix/json"
#define kDAPI_origins       @"origins"
#define kDAPI_destinations  @"destinations"
#define kDAPI_mode          @"mode"
#define kDAPI_language      @"language"
#define kDAPI_sensor        @"sensor"


/** Client for the Google Distance API. */
@interface DistanceAPIClient : NSObject

/** 
 * Return the driving time between origin and destination. 
 *
 * @param origin Origin. Use coordinates @"40.417009,-3.703482" or text @"Puerta del Sol, Madrid".
 * @param destination Destination.
 * @param success Block to run if success.
 * @param failure Block to run if failure.
 */
-(void) drivingTimeBetweenOrigin: (NSString*) origin 
                     destination: (NSString*) destination
                         success: (AFJSONSuccess) success
                         failure: (AFJSONFailure) failure;

@end
