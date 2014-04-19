#import "VENViewController.h"
#import "VENRemoteUserDefaultsManager.h"

@interface VENViewController ()

@property (strong, nonatomic) IBOutlet UISwitch *switchView;

@end

@implementation VENViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:@"switchON"];
    [self.switchView setOn:on];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userTappedUpdateDefaults:(id)sender {
    [[VENRemoteUserDefaultsManager sharedManager] updateRemoteDefaults];
}


- (IBAction)userTappedSwitch:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"switchON"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
