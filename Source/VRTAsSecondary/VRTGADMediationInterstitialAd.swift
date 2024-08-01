// Google Mobile Ads Banner Adapter, Vrtcal as Secondary

import GoogleMobileAds
import VrtcalSDK



class VRTGADMediationInterstitialAd: NSObject, GADMediationInterstitialAd {

    
    /// Completion handler called after ad load
    var completionHandler: GADMediationInterstitialLoadCompletionHandler?
    weak var delegate: GADMediationInterstitialAdEventDelegate?
    
    /// Interstitial
    var vrtInterstitial: VRTInterstitial?
    weak var viewControllerForModalPresentation: UIViewController?
    
    func loadInterstitial(
        for adConfiguration: GADMediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        VRTLogInfo()
        
        // Get the Zone ID
        let result = adConfiguration.credentials.get(intSetting: "zid")
        guard case let .success(zoneId) = result else {
            let vrtError = result.getError()
            _ = completionHandler(nil, vrtError)
            return
        }
        
        self.completionHandler = completionHandler
        
        // Make a VRTInterstitial
        self.vrtInterstitial = VRTInterstitial()
        
        // Load
        vrtInterstitial?.adDelegate = self
        vrtInterstitial?.loadAd(zoneId)
    }
    
    func present(from viewController: UIViewController) {
        VRTLogInfo()
        self.viewControllerForModalPresentation = viewController
    }
}


extension VRTGADMediationInterstitialAd: VRTInterstitialDelegate {

    func vrtViewControllerForModalPresentation() -> UIViewController? {
        VRTLogInfo()
        return self.viewControllerForModalPresentation
    }
    
    func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        delegate = completionHandler?(self, nil)
    }
    
    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: any Error) {
        VRTLogInfo()
        _ = completionHandler?(nil, error)
    }
    
    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        delegate?.willPresentFullScreenView()
    }
    
    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: any Error) {
        VRTLogInfo()
        delegate?.didFailToPresentWithError(error)
    }
    
    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        delegate?.reportClick()
    }
    
    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        delegate?.willDismissFullScreenView()
    }
    
    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
}
