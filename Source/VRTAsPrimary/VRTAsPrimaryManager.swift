import GoogleMobileAds
import VrtcalSDK




class VRTAsPrimaryManager {
    static let singleton = VRTAsPrimaryManager()
    private var shouldInit = true
    
    func initializeThirdParty(
        completionHandler: @escaping (Result<Void, VRTError>) -> ()
    ) {

        guard shouldInit else {
            completionHandler(.success())
            return
        }

        shouldInit = false
        GADMobileAds.sharedInstance().disableMediationInitialization()
        GADMobileAds.sharedInstance().start { _ in
            completionHandler(.success())
        }
    }
    
}
