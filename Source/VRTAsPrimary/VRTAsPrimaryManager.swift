import GoogleMobileAds
import VrtcalSDK




class VRTAsPrimaryManager {
    static let singleton = VRTAsPrimaryManager()
    private var shouldInit = true
    
    func initializeThirdParty(
        completionHandler: @escaping () -> ()
    ) {

        guard shouldInit else {
            completionHandler()
            return
        }

        shouldInit = false
        GADMobileAds.sharedInstance().disableMediationInitialization()
        GADMobileAds.sharedInstance().start { _ in
            completionHandler()
        }
    }
}
