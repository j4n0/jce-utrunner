
#import <Cocoa/Cocoa.h>
#import "UTRunner.h"

int main(int argc, const char * argv[])
{
    // return NSApplicationMain(argc, (const char **)argv);
    @autoreleasepool {
        UTRunner *runner = [UTRunner new];
        [runner runAllClasses];
        [runner printReport];
    }
    return 0;
}

