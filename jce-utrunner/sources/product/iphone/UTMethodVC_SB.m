
// BSD License. Author: jano at jano.com.es

#import "UTMethodVC_SB.h"

@interface UTMethodVC_SB ()
@property (nonatomic, strong) UTRunner *utRunner;                    // test runner
@property (nonatomic, strong) IBOutlet UILabel *label;               // method name
@property (nonatomic, strong) IBOutlet UITextView *textView;         // execution result
@property (nonatomic, strong) IBOutlet UIBarButtonItem *buttonItem;  // 'run' button
@end


@implementation UTMethodVC_SB

@synthesize utRunner = _utRunner;
@synthesize utMethod = _utMethod;
@synthesize buttonItem = _buttonItem;
@synthesize textView = _textView;
@synthesize label = _label;

/* Run the method and display the result. */
-(IBAction)run:(id)sender 
 {
    debug(@"run %@",NSStringFromSelector(method_getName(self.utMethod.method)));
    [self.utRunner runMethod:self.utMethod];
    self.textView.text = [self.utMethod description];
}

# pragma mark - UIViewController

-(void) viewDidLoad 
{
    [super viewDidLoad];
    self.utRunner = [UTRunner new];    
    // set method name and error detail from previous execution (if any)
    self.label.text = NSStringFromSelector(method_getName(self.utMethod.method));
    if (self.utMethod.errorDetail!=nil) {
        self.textView.text = self.utMethod.errorDetail;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
