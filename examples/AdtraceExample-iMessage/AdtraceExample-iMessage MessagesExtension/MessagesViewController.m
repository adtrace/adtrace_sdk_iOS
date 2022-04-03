







#import "Adtrace.h"
#import "MessagesViewController.h"

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnTrackEvent;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *yourAppToken = @"2fm9gkqubvpc";
        NSString *environment = ADTEnvironmentSandbox;
        ADTConfig *adtraceConfig = [ADTConfig configWithAppToken:yourAppToken environment:environment];

        
        [adtraceConfig setLogLevel:ADTLogLevelVerbose];

        
        [Adtrace addSessionCallbackParameter:@"sp_foo" value:@"sp_bar"];
        [Adtrace addSessionCallbackParameter:@"sp_key" value:@"sp_value"];

        
        [Adtrace addSessionPartnerParameter:@"sp_foo" value:@"sp_bar"];
        [Adtrace addSessionPartnerParameter:@"sp_key" value:@"sp_value"];

        
        [Adtrace removeSessionCallbackParameter:@"sp_key"];

        
        [Adtrace removeSessionPartnerParameter:@"sp_foo"];

        
        [Adtrace appDidLaunch:adtraceConfig];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    
    
    
    

    [Adtrace trackSubsessionStart];
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    
    
    
    
    
    
    

    [Adtrace trackSubsessionEnd];
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    
    
    
    
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    
    
    
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    
    
    
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    
    
    
}

- (IBAction)clickTrackSimpleEvent:(id)sender {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"g3mfiw"];
    [Adtrace trackEvent:event];
}

@end
