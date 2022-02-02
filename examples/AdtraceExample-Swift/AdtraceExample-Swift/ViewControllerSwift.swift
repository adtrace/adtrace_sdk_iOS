







import UIKit
import AppTrackingTransparency
import AdSupport

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
    
    lazy var loadProductController: ProductLoadable? = {
        if #available(iOS 14.0, *) {
            return LoadProductController()
        }
        
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnAskPermission(_sender: UIButton) {
        if #available(iOS 14, *) {
            print("status notDetermined == \(ATTrackingManager.trackingAuthorizationStatus == .notDetermined)")
            print("status authorized == \(ATTrackingManager.trackingAuthorizationStatus == .authorized)")
            print("IDFA == \(ASIdentifierManager.shared().advertisingIdentifier)")
            ATTrackingManager.requestTrackingAuthorization { (status) in
                print("IDFA == \(ASIdentifierManager.shared().advertisingIdentifier)")
                print("authorized == \(status == .authorized)")
                print("denied == \(status == .denied)")
                print("restricted == \(status == .restricted)")
            }
        }
    }
    
    @IBAction func btnLoadProduct(_sender: UIButton) {
        loadProductController?.loadProduct(from: self)
    }

    @IBAction func btnTrackEventSimpleTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "v02d2i");

        
        event?.setCallbackId("RandomCallbackId")

        Adtrace.trackEvent(event);
    }

    @IBAction func btnTrackEventRevenueTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "a4fd35")

        
        event?.setRevenue(0.01, currency: "EUR");

        Adtrace.trackEvent(event);
    }

    @IBAction func btnTrackEventCallbackTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "v02d2i");

        
        event?.addCallbackParameter("foo", value: "bar");
        event?.addCallbackParameter("key", value: "value");

        Adtrace.trackEvent(event);
    }

    @IBAction func btnTrackEventPartnerTapped(_sender: UIButton) {
        let event = ADTEvent(eventToken: "v02d2i");

        
        event?.addParameter("foo", value: "bar");
        event?.addParameter("key", value: "value");

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
