//
//  AppDelegate.swift
//  AdtraceExample-Swift
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AdtraceDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appToken = "2fm9gkqubvpc"
        let environment = ADTEnvironmentSandbox
        let adtraceConfig = ADTConfig(appToken: appToken, environment: environment)

        // Change the log level.
        adtraceConfig?.logLevel = ADTLogLevelVerbose

        // Enable event buffering.
        // adtraceConfig?.eventBufferingEnabled = true

        // Set default tracker.
        // adtraceConfig?.defaultTracker = "{TrackerToken}"

        // Send in the background.
        // adtraceConfig?.sendInBackground = true
        
        // Set delegate object.
        adtraceConfig?.delegate = self
        
        // Delay the first session of the SDK.
        // adtraceConfig?.delayStart = 7
        
        // Add session callback parameters.
        Adtrace.addSessionCallbackParameter("obi", value: "wan")
        Adtrace.addSessionCallbackParameter("master", value: "yoda")
        
        // Add session partner parameters.
        Adtrace.addSessionPartnerParameter("darth", value: "vader")
        Adtrace.addSessionPartnerParameter("han", value: "solo")
        
        // Remove session callback parameter.
        Adtrace.removeSessionCallbackParameter("obi")
        
        // Remove session partner parameter.
        Adtrace.removeSessionPartnerParameter("han")
        
        // Remove all session callback parameters.
        // Adtrace.resetSessionCallbackParameters()
        
        // Remove all session partner parameters.
        // Adtrace.resetSessionPartnerParameters()

        // Initialise the SDK.
        Adtrace.appDidLaunch(adtraceConfig!)

        // Put the SDK in offline mode.
        // Adtrace.setOfflineMode(true);
        
        // Disable the SDK
        // Adtrace.setEnabled(false);
        
        // Interrupt delayed start set with setDelayStart: method.
        // Adtrace.sendFirstPackages()

        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        NSLog("Scheme based deep link opened an app: %@", url.absoluteString)
        // Pass deep link to Adtrace in order to potentially reattribute user.
        Adtrace.appWillOpen(url)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            NSLog("Universal link opened an app: %@", userActivity.webpageURL!.absoluteString)
            // Pass deep link to Adtrace in order to potentially reattribute user.
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
