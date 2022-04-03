







import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdtraceDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appToken = "2fm9gkqubvpc"
        let environment = ADTEnvironmentSandbox
        let adtraceConfig = ADTConfig(appToken: appToken, environment: environment)

        
        adtraceConfig?.logLevel = ADTLogLevelVerbose

        
        

        
        

        
        
        
        
        adtraceConfig?.delegate = self
        
        
        
        
        
        Adtrace.addSessionCallbackParameter("obi", value: "wan")
        Adtrace.addSessionCallbackParameter("master", value: "yoda")
        
        
        Adtrace.addSessionPartnerParameter("darth", value: "vader")
        Adtrace.addSessionPartnerParameter("han", value: "solo")
        
        
        Adtrace.removeSessionCallbackParameter("obi")
        
        
        Adtrace.removeSessionPartnerParameter("han")
        
        
        
        
        
        

        
        Adtrace.appDidLaunch(adtraceConfig!)

        
        
        
        
        
        
        
        

        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        NSLog("Scheme based deep link opened an app: %@", url.absoluteString)
        
        Adtrace.appWillOpen(url)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            NSLog("Universal link opened an app: %@", userActivity.webpageURL!.absoluteString)
            
            Adtrace.appWillOpen(userActivity.webpageURL!)
        }
        return true
    }

    func adtraceAttributionChanged(_ attribution: ADTAttribution?) {
        NSLog("Attribution callback called!")
        NSLog("Attribution: %@", attribution ?? "")
    }

    func adtraceEventTrackingSucceeded(_ eventSuccessResponseData: ADTEventSuccess?) {
        NSLog("Event success callback called!")
        NSLog("Event success data: %@", eventSuccessResponseData ?? "")
    }

    func adtraceEventTrackingFailed(_ eventFailureResponseData: ADTEventFailure?) {
        NSLog("Event failure callback called!")
        NSLog("Event failure data: %@", eventFailureResponseData ?? "")
    }

    func adtraceSessionTrackingSucceeded(_ sessionSuccessResponseData: ADTSessionSuccess?) {
        NSLog("Session success callback called!")
        NSLog("Session success data: %@", sessionSuccessResponseData ?? "")
    }

    func adtraceSessionTrackingFailed(_ sessionFailureResponseData: ADTSessionFailure?) {
        NSLog("Session failure callback called!");
        NSLog("Session failure data: %@", sessionFailureResponseData ?? "")
    }

    func adtraceDeeplinkResponse(_ deeplink: URL?) -> Bool {
        NSLog("Deferred deep link callback called!")
        NSLog("Deferred deep link URL: %@", deeplink?.absoluteString ?? "")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
