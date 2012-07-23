
// BSD License. Author: jano at jano.com.es

#import "SomeTest.h"

@implementation SomeTest

-(void) setupClass {
    // setup the class
}

// This method takes 0.1 to execute.
-(void) testWhatever {
    debug(@"whatever");
    [NSThread sleepForTimeInterval:0.1];
}

// This method throws exception. 
-(void) testSomeFailure {
    debug(@"here it comes...");
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    [info setValue:[NSString stringWithUTF8String:__FILE__] forKey:@"file"];
    [info setValue:[NSNumber numberWithInt:__LINE__] forKey:@"line"];
    NSException *exception = [NSException exceptionWithName:@"KenTacoHutException" 
                                                     reason:@"Not real food." 
                                                   userInfo:info];
    @throw exception;
}

// This method tests an expression.
-(void) testSomeExpression {
    UTAssertTrue(true, @"This shouldn't fail.");
    UTAssertTrue(false, @"The expression should be true.");
}

@end
