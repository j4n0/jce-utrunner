Poor man's unit test library.

![](https://github.com/j4n0/jce-utrunner/raw/master/jce-utrunner/Sources/resources/screenshot.png)

### Usage

Create a subclass of UTCase. Example:

    #import "UnitTestCase.h"
    @interface SomeTest : UTCase
    -(void) testWhatever;
    @end

    #import "SomeTest.h"
    @implementation SomeTest
    -(void) testWhatever {
        debug(@"tested!");
    }
    @end

Test methods should return void and start with the "test" preffix.  
Optionally override any of the methods of UTCase.
