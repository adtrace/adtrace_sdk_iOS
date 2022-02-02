







#import "Adtrace.h"
#import "Constants.h"
#import "ViewControllertvOS.h"

@interface ViewControllertvOS ()

@property (weak, nonatomic) IBOutlet UIButton *btnTrackSimpleEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackRevenueEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackCallbackEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackPartnerEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnEnableOfflineMode;
@property (weak, nonatomic) IBOutlet UIButton *btnDisableOfflineMode;
@property (weak, nonatomic) IBOutlet UIButton *btnEnableSdk;
@property (weak, nonatomic) IBOutlet UIButton *btnDisableSdk;
@property (weak, nonatomic) IBOutlet UIButton *btnIsSdkEnabled;

@end

@implementation ViewControllertvOS

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clickTrackSimpleEvent:(UIButton *)sender {
    ADTEvent *event = [ADTEvent eventWithEventToken:kEventToken1];

    [Adtrace trackEvent:event];
}

- (IBAction)clickTrackRevenueEvent:(UIButton *)sender {
    ADTEvent *event = [ADTEvent eventWithEventToken:kEventToken2];

    
    [event setRevenue:0.01 currency:@"EUR"];

    [Adtrace trackEvent:event];
}

- (IBAction)clickTrackCallbackEvent:(UIButton *)sender {
    ADTEvent *event = [ADTEvent eventWithEventToken:kEventToken3];

    
    [event addCallbackParameter:@"a" value:@"b"];
    [event addCallbackParameter:@"key" value:@"value"];
    [event addCallbackParameter:@"a" value:@"c"];

    [Adtrace trackEvent:event];
}

- (IBAction)clickTrackPartnerEvent:(UIButton *)sender {
    ADTEvent *event = [ADTEvent eventWithEventToken:kEventToken4];

    
    [event addPartnerParameter:@"x" value:@"y"];
    [event addPartnerParameter:@"foo" value:@"bar"];
    [event addPartnerParameter:@"x" value:@"z"];

    [Adtrace trackEvent:event];
}

- (IBAction)clickEnableOfflineMode:(id)sender {
    [Adtrace setOfflineMode:YES];
}

- (IBAction)clickDisableOfflineMode:(id)sender {
    [Adtrace setOfflineMode:NO];
}

- (IBAction)clickEnableSdk:(id)sender {
    [Adtrace setEnabled:YES];
}

- (IBAction)clickDisableSdk:(id)sender {
    [Adtrace setEnabled:NO];
}

- (IBAction)clickIsSdkEnabled:(id)sender {
    NSString *message;

    if ([Adtrace isEnabled]) {
        message = @"SDK is ENABLED!";
    } else {
        message = @"SDK is DISABLED!";
    }

    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Is SDK Enabled?"
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
