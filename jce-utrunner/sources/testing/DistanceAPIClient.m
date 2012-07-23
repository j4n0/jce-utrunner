
// BSD License. Author: jano at jano.com.es

#import "DistanceAPIClient.h"

@implementation DistanceAPIClient

/**
 * Returns a distance matrix API url for the given origin and destination.
 * @param origin The origin. Use coordinates @"40.417009,-3.703482" or text @"Puerta del Sol, Madrid".
 * @param destination The destination.
 */
-(NSURL*) urlForOrigin:(NSString*)origin destination:(NSString*)destination 
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:origin      forKey:kDAPI_origins];
    [query setObject:destination forKey:kDAPI_destinations];
    [query setObject:@"driving"  forKey:kDAPI_mode];
    [query setObject:@"en"       forKey:kDAPI_language];
    [query setObject:@"false"    forKey:kDAPI_sensor];
    
    NSString *baseURL = kDAPI_URL;
    return [self urlWithBaseURL:baseURL andParameters:query];
}

/**
 * Return an URL made with a base string and some query parameters.
 *
 * @param baseURL The base url, eg: @"https://www.google.com/search".
 * @param query The parameters, eg: [NSDictionary dictionaryWithObject:@"bacon" forKey:@"q"].
 */
-(NSURL*) urlWithBaseURL:(NSString*)baseURL andParameters:(NSDictionary*)query 
{
    NSMutableArray *queryComponents = [NSMutableArray array];
    for (__strong NSString *key in query) {
        NSString *value = [query objectForKey:key];
        key = [key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        value = [value stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *component = [NSString stringWithFormat:@"%@=%@", key, value];
        [queryComponents addObject:component];
    }
    NSString *queryString = [queryComponents componentsJoinedByString:@"&"];
    
    NSString *fullURLString = [NSString stringWithFormat:@"%@?%@", baseURL, queryString];
    NSURL *newURL = [NSURL URLWithString:fullURLString];
    
    return newURL;
}


// see .h
-(void) drivingTimeBetweenOrigin: (NSString*) origin 
                     destination: (NSString*) destination
                         success: (AFJSONSuccess) success
                         failure: (AFJSONFailure) failure 
{
    NSURL* url = [self urlForOrigin:@"Puerta del Sol, Madrid" destination:@"Cuzco,Madrid"]; 
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request 
                                                                                        success: success
                                                                                        failure: failure];
    [operation start];
}

@end
