







#import "Adtrace.h"
#import "ViewControllerWatch.h"
#import "AdtraceTrackingHelper.h"

@interface ViewControllerWatch ()

@property (weak, nonatomic) IBOutlet UIButton *btnTrackSimpleEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackRevenueEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackEventWithCallback;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackEventWithPartner;

@end

@implementation ViewControllerWatch

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)btnTrackSimpleEventTapped:(UIButton *)sender {
    [[AdtraceTrackingHelper sharedInstance] trackSimpleEvent];
}
- (IBAction)btnTrackRevenueEventTapped:(UIButton *)sender {
    [[AdtraceTrackingHelper sharedInstance] trackRevenueEvent];
}
- (IBAction)btnTrackCallbackEventTapped:(UIButton *)sender {
    [[AdtraceTrackingHelper sharedInstance] trackCallbackEvent];
}
- (IBAction)btnTrackEventValueTapped:(UIButton *)sender {
    [[AdtraceTrackingHelper sharedInstance] trackEventValue];
}

@end
