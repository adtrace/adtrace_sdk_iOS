//
//  ViewController.swift
//  AdjustExample-Swift
//
//  Created by Uglješa Erceg on 06/04/16.
//  Copyright © 2016 adjust GmbH. All rights reserved.
//

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnTrackEventSimpleTapped(_sender: UIButton) {
        let event = ADJEvent(eventToken: "g3mfiw");

        Adtrace.trackEvent(event);
    }

    @IBAction func btnTrackEventRevenueTapped(_sender: UIButton) {
        let event = ADJEvent(eventToken: "a4fd35")
        event?.setRevenue(0.99, currency: "EUR");

        Adtrace.trackEvent(event);
    }

    @IBAction func btnTrackEventCallbackTapped(_sender: UIButton) {
        let event = ADJEvent(eventToken: "34vgg9");
        event?.addCallbackParameter("foo", value: "bar");
        event?.addCallbackParameter("key", value: "value");

        Adtrace.trackEvent(event);
    }

    @IBAction func btnTrackEventPartnerTapped(_sender: UIButton) {
        let event = ADJEvent(eventToken: "w788qs");
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
