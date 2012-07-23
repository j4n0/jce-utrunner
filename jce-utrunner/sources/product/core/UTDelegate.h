
#import "UTMethod.h"
#import "UTClass.h"

/** Delegate protocol. */
@protocol UTDelegate <NSObject>

@optional

/** 
 * Called before the method is tested. 
 * @param method Method whose testing just finished.
 */
-(void) testWillStartOnMethod:(UTMethod*)method;

/** 
 * Called after the method is tested. 
 * @param method Method whose testing just finished.
 */
-(void) testDidFinishOnMethod:(UTMethod*)method;

/** 
 * Called before the class is tested. 
 * @param clazz Class whose testing just finished.
 */
-(void) testWillStartOnClass:(UTClass*)clazz;

/** 
 * Called after the class is tested. 
 * @param clazz Class whose testing just finished.
 */
-(void) testDidFinishOnClass:(UTClass*)clazz;

@end
