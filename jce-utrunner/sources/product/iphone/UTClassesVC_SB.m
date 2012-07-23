
// BSD License. Author: jano at jano.com.es

#import "UTClassesVC_SB.h"

@interface UTClassesVC_SB ()
@property (nonatomic, strong) IBOutlet UIBarButtonItem *buttonItem;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UTMethod *selectedMethod;
@property (nonatomic, strong) UTRunner *utRunner;
@end


@implementation UTClassesVC_SB

@synthesize tableView = _tableView;
@synthesize utRunner = _utRunner;
@synthesize buttonItem = _buttonItem;
@synthesize selectedMethod = _selectedMethod;

-(IBAction)run:(id)sender {
    // run everything and refresh the table
    [self.utRunner runAllClasses];
    [self.tableView reloadData];
}

# pragma mark - UTDelegate

-(void) testWillStartOnMethod:(UTMethod*)method {
}

-(void) testWillFinishOnMethod:(UTMethod*)method {
    // refresh method by method using reloadRowsAtIndexPaths:withRowAnimation:
}

# pragma mark - UIViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    self.utRunner = [UTRunner new];
    self.utRunner.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{ 
    if ([[segue identifier] isEqualToString:@"toUTMethodVC"]) {
        // set the method to test in the next controller
        UTMethodVC_SB *vc = [segue destinationViewController];
        vc.utMethod = self.selectedMethod;
    }
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // set selected method to be picked up at prepareForSegue:
    UTClass *utClass = [self.utRunner.testCases objectAtIndex:indexPath.section];
    UTMethod *utMethod = [utClass.methods objectAtIndex:indexPath.row];
    self.selectedMethod = utMethod;
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    [self performSegueWithIdentifier:@"toUTMethodVC" sender:indexPath];
}


# pragma mark - UITableViewDataSource

// Each section has a class and their test methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    UTClass *utClass = [self.utRunner.testCases objectAtIndex:section];
    return NSStringFromClass(utClass.clazz);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [self.utRunner.testCases count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    UTClass *utClass = [self.utRunner.testCases objectAtIndex:section];
    return [utClass.methods count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    int row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UTClass *utClass = [self.utRunner.testCases objectAtIndex:indexPath.section];
    UTMethod *utMethod = [utClass.methods objectAtIndex:row];
    
    NSString *name = NSStringFromSelector(method_getName(utMethod.method));
    BOOL isTested = utMethod.time>0.000001;
    if (isTested){
        // case where we ran this method at least once, so set the name and time
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", utMethod.success?@"✔ ":@"✘ ", name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f",utMethod.time];
    } else {
        cell.textLabel.text = name;
    }
    
    return cell;
}

@end




