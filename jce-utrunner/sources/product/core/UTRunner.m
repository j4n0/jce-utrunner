
#import "UTRunner.h"

@implementation UTRunner

@synthesize testCases = _testCases;
@synthesize delegate = _delegate;


/** 
 * Return registered classes matching the given condition. 
 * @param filter Criteria to include/exclude classes.
 */
- (NSMutableArray*) classesMatchingCondition:(ClassFilterBlock) filter {
    
    // class definitions
    int count = objc_getClassList(NULL, 0);
    Class *classPtr = (Class*) malloc(count*sizeof(Class));
    
    // fill the buffer
    objc_getClassList(classPtr, count);
    
    // iterate the buffer
    NSMutableArray *utClasses = [NSMutableArray array];    
    for (int i = 0; i < count; ++i) 
    {
        Class clazz = classPtr[i];        
        if (filter(clazz)){
            // discard if it is disabled
            if ([self isDisabled:clazz]) {
                debug(@"%@ is disabled", clazz);
                continue;
            }
            // build a UTClass and add to the array of classes to test
            UTClass *utClass = [[UTClass alloc] initWithClass:clazz];
            [utClasses addObject:utClass];
        }
    }
    
    free(classPtr);
    return utClasses;
}

 
/** Returns TRUE if there is an ivar with name "test_disabled". */
-(BOOL) isDisabled:(Class)clazz {
    Ivar ivar = class_getInstanceVariable(clazz, "test_disabled");
    return ivar!=NULL;
}


/** 
 * Return instance methods of the given class matching the given condition. 
 *
 * @param filter Filter to exclude/include methods.
 * @param clazz asfsfjskfhdskjgds
 */
-(NSArray*) methodsMatchingCondition:(MethodFilterBlock)filter forClass:(Class)clazz
{
    // number of methods in the class
    unsigned int count;
    Method *methods = class_copyMethodList(clazz, &count);
    if (count==0) { 
        return [NSArray array];
    }
    
    // iterate the methods
    NSMutableArray *utMethods = [NSMutableArray array];
    for (size_t j = 0; j<count; ++j) {
        Method method = methods[j];
        if (filter(method)){
            // add the method wrapped on NSData
            UTMethod *utMethod = [[UTMethod alloc] initWithMethod:method fromClass:clazz];
            [utMethods addObject:utMethod];
        }
    }
    
    return utMethods;
}


-(NSMutableArray*) testCasesWithClassFilter:(ClassFilterBlock)classFilter methodFilter:(MethodFilterBlock)methodFilter
{
    NSMutableArray *testCases = [self classesMatchingCondition:classFilter];
    for (UTClass *utClass in [testCases copy]){
        NSArray *methods = [self methodsMatchingCondition:methodFilter forClass:utClass.clazz];
        if ([methods count]==0){
            [testCases removeObject:utClass];
        } else {
            utClass.methods = methods;
        }
    }
    return testCases;
}


-(void) runAllClasses
{    
    for (UTClass *utClass in self.testCases){
        [self runClass:utClass];
    }
    debug(@"Done.");
}


-(void) printReport {
    for (UTClass *utClass in self.testCases){
        debug(@"Report:\n%@",[utClass report]);
    }
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:1];
    while ([timeout timeIntervalSinceNow]>0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}


-(void) runClass:(UTClass*)utClass
{
    Class clazz = utClass.clazz;
    id testCase = [clazz new];

    NSDate *startTime = [NSDate date];
    [testCase setupClass];    
    for (UTMethod *utMethod in utClass.methods) {
        [self runMethod:utMethod onInstance:testCase];
    }
    [testCase teardownClass]; 
    
    utClass.time = -[startTime timeIntervalSinceNow];
}


-(void) runMethod:(UTMethod*)utMethod 
{
    Class clazz = utMethod.clazz;
    id testCase = [clazz new];
    [testCase setupClass];    

    if ([self.delegate respondsToSelector:@selector(testWillStartOnMethod:)]) 
        [self.delegate testWillStartOnMethod:utMethod];
    NSDate *startTime = [NSDate date];
    [self runMethod:utMethod onInstance:testCase];
    utMethod.time = -[startTime timeIntervalSinceNow];    
    if ([self.delegate respondsToSelector:@selector(testDidFinishOnMethod:)]) 
        [self.delegate testDidFinishOnMethod:utMethod];
    
    [testCase teardownClass];
}


/** 
 * Run the given method.
 * This calls setupMethod/teardownMethod before/after the given method.
 * @param utMethod Method to run.
 * @param testCase Instance we are calling the method on.
 */
-(void) runMethod:(UTMethod*)utMethod onInstance:(UTCase*)testCase 
{
    if ([self.delegate respondsToSelector:@selector(testWillStartOnMethod:)]){
        [self.delegate testWillStartOnMethod:utMethod];
    }
    [testCase setupMethod];
    NSDate *startTime = [NSDate date];
    @try 
    {
        // We are not allocating and returning any object because 
        // the returned type is void so I'm disabling the warning
        // "PerformSelector may cause a leak because its selector is unknown"
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [testCase performSelector:method_getName(utMethod.method)];
        #pragma clang diagnostic pop
        utMethod.success = TRUE;
        utMethod.errorDetail = nil;
    } 
    @catch (NSException *e) 
    {
        fprintf(stdout, "ouch!");
        NSDictionary *info = [e userInfo];
        NSString *detail = [NSString stringWithFormat:@"%@: %@\n      %@:%@", 
                            [e name], [e reason], [info valueForKey:@"file"], [info valueForKey:@"line"]];
        utMethod.errorDetail = detail;
    }
    utMethod.time = -[startTime timeIntervalSinceNow];
    [testCase teardownMethod];
    if ([self.delegate respondsToSelector:@selector(testDidFinishOnMethod:)]) {
        [self.delegate testDidFinishOnMethod:utMethod];
    }
}


#pragma mark - NSObject

-(id) init {
    if (self = [super init]){
        ClassFilterBlock classFilter = [self buildClassFilterBlock];
        MethodFilterBlock methodFilter = [self buildMethodFilterBlock];
        _testCases = [self testCasesWithClassFilter:classFilter methodFilter:methodFilter];
    }
    return self;
}


/** @return Block that returns true for subclasses of UnitTestCase. */
-(ClassFilterBlock) buildClassFilterBlock {
    
    ClassFilterBlock isTestCase = ^bool(Class clazz) {
        
        // FYI: when NSZombieEnabled is enabled, there are zombie classes being deallocated during runtime.
        // FYI: not all classes registered at runtime are subclasses of NSObject.
        
        // discard zombies
        NSString *className = NSStringFromClass(clazz);
        BOOL isZombie = [className rangeOfString:@"NSZombie"].location!=NSNotFound;
        if (isZombie) return FALSE;

        // return true if UnitTestCase is a parent of this class
        Class superclass = clazz;
        do {
            superclass = class_getSuperclass(superclass);
            if ([NSStringFromClass(superclass) isEqualToString:NSStringFromClass([UTCase class])]) return TRUE;
        } while (superclass!=nil);
        
        return FALSE;
    };
    
    return isTestCase;
}


/** @return Block that returns true for methods starting with test and returning void. */
-(MethodFilterBlock) buildMethodFilterBlock 
{    
    MethodFilterBlock isTestMethod = ^bool(Method method) {
        // starts with test
        SEL sel = method_getName(method);
        BOOL hasPrefix = [NSStringFromSelector(sel) hasPrefix:@"test"];
        if (!hasPrefix) return FALSE;
        // returns void
        char *returnType = method_copyReturnType(method); // this returns v (void) or @ (object)
        BOOL returnsVoid = strcmp(returnType, @encode(void)) == 0;
        // has 0 arguments
        BOOL noArguments = method_getNumberOfArguments(method) == 2; // 1 and 2 are hidden arguments self and _cmd
        return hasPrefix && returnsVoid && noArguments;
    };
    return isTestMethod;
}


#pragma mark - UnitDelegate

-(void) testWillStartOnMethod:(UTMethod*)utMethod {}
-(void) testWillFinishOnMethod:(UTMethod*)utMethod {}
-(void) testWillStartOnClass:(Class)clazz {}
-(void) testWillFinishOnClass:(Class)clazz {}


@end
