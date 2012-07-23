
#import "UTCase.h"

NSString *stringWithArguments(NSString *description, ...) {
    if (description==nil) return @"";
    va_list ap;
    va_start(ap, description);
    NSString *string = [[NSString alloc] initWithFormat:description arguments:ap];
    va_end(ap);
    return string;
}

@implementation UTCase

@synthesize finished = _finished;

-(void) setupClass {}
-(void) teardownClass {}

-(void) setupMethod {}
-(void) teardownMethod {}

/**
 * Test that the block fires a notification in less than 'expiration' seconds.
 * If the notification.object is NSError, the test counts as failed.
 * Usage: [super runBlock:^{ [regionModel taxis]; } timeLimit:20.0 notification:kTaxisNotification];
 *
 */
-(void) runBlock:(void(^)(void))block timeLimit:(NSTimeInterval)expiration notification:(NSString*)notification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleNotification:) name:notification object:nil];
    
    self.finished = false;
    block();
    
    NSDate *startTime = [NSDate date];
    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:startTime];
    
    bool isExpired = false;
    while (!self.finished && !isExpired)
    {
        // loop one second
        NSDate *oneSecond = [NSDate dateWithTimeInterval:1 sinceDate:[NSDate date]];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
        
        elapsed = [[NSDate date] timeIntervalSinceDate:startTime];
        isExpired = elapsed > expiration;
    }
    
    [center removeObserver:self];
    
    if (isExpired){
        UTAssertTrue(false, @"Task expired after %.f seconds",expiration);
    }
}


-(void) handleNotification:(NSNotification*)notification 
{
    //debug(@"notification.object = ", notification.object);
    self.finished = true;
    if ([notification.object isKindOfClass:[NSError class]])
    {
        NSError *error = notification.object;
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSString stringWithFormat:@"domain:%@, code:%d", error.domain, error.code]];
        id failingURLKey = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];
        id localizedDescription = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        if (failingURLKey) [array addObject:failingURLKey];
        if (localizedDescription) [array addObject:localizedDescription];
        NSString *string = [array componentsJoinedByString:@"\n\t"];
        UTAssertTrue(false, @"Task ended with error... \n\t%@",string);
    } 
    else 
    {
        id object = notification.object;
        debug(@"Sucess. Got notification %@",object);
        UTAssertTrue(true, nil);
    }
}


@end

