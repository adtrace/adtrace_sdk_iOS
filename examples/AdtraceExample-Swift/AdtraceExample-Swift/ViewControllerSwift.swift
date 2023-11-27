//
//  ViewController.swift
//  AdtraceExample-Swift
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016.
//  Copyright © 2016-Present Adtrace GmbH. All rights reserved.
//

import AppTrackingTransparency
import AdSupport
import Adtrace_sdk
import UIKit

class ViewControllerSwift: UIViewController {
    @IBOutlet weak var btnTrackEventSimple: UIButton?
    @IBOutlet weak var btnTrackEventRevenue: UIButton?
    @IBOutlet weak var btnTrackEventCallback: UIButton?
    @IBOutlet weak var btnTrackEventPartner: UIButton?
    @IBOutlet weak var btnEnableOfflineMode: UIButton?
    @IBOutlet weak var btnDisableOfflineMode: UIButton?
    @IBOutlet weak var btnEnableSDK: UIButton?
    @IBOutlet weak var btnDisableSDK: UIButton?
    @IBOutlet weak var btnIsSDKEnabled: UIButton?
    
    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    @IBAction func btnTrackEventSimpleTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "i53rc7");
        Adtrace.trackEvent(event);
    }
    
    @IBAction func btnTrackEventRevenueTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "drv45k")

        // Add revenue 1 cent of an EURO.
        event?.setRevenue(12000.0, currency: "Rial");

        Adtrace.trackEvent(event);
    }
    
    @IBAction func btnTrackEventCallbackTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "3vgls9");
        
        // Add callback parameters to this event.
        event?.addCallbackParameter("foo", value: "bar");
        event?.addCallbackParameter("key", value: "value");
        
        Adtrace.trackEvent(event);
    }
    
    @IBAction func btnTrackEventPartnerTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "8ihwpl");
        
        // Add partner parameteres to this event.
        event?.addPartnerParameter("foo", value: "bar");
        event?.addPartnerParameter("key", value: "value");
        
        Adtrace.trackEvent(event);
    }
    
    @IBAction func btnEnableOfflineModeTapped(_sender: UIButton) {
        Adtrace.setOfflineMode(true);
    }
    
    @IBAction func btnDisableOfflineModeTapped(_sender: UIButton) {
        Adtrace.setOfflineMode(false);
    }
    
    @IBAction func btnEnableSDKTapped(_sender: UIButton) {
        Adtrace.setEnabled(true);
    }
    
    @IBAction func btnDisableSDKTapped(_sender: UIButton) {
        Adtrace.setEnabled(false);
    }
    
    @IBAction func btnIsSDKEnabledTapped(_sender: UIButton) {
        let isSDKEnabled = Adtrace.isEnabled();
        if (isSDKEnabled) {
            NSLog("SDK is enabled!");
        } else {
            NSLog("SDK is disabled");
        }
    }
}
