







#import "EventTrackedController.h"

@interface EventTrackedController ()

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *wkLblMessage;

@end

@implementation EventTrackedController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [_wkLblMessage setText:context];
}

- (void)willActivate {
    
    [super willActivate];
}

- (void)didDeactivate {
    
    [super didDeactivate];
}

- (IBAction)btnOkTapped {
    [self popToRootController];
}

@end



