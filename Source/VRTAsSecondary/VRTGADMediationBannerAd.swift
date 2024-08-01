// Google Mobile Ads Banner Adapter, Vrtcal as Secondary

import GoogleMobileAds
import VrtcalSDK



class VRTGADMediationBannerAd: NSObject, GADMediationBannerAd {

    var view: UIView {
        return vrtBanner ?? UIView()
    }
    
    /// The Sample Ad Network banner ad.
    var vrtBanner: VRTBanner?

    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    var delegate: GADMediationBannerAdEventDelegate?

    /// Completion handler called after ad load
    var completionHandler: GADMediationBannerLoadCompletionHandler?

    override init() {
        super.init()
    }
    
    func loadBanner(
        for adConfiguration: GADMediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
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
        
        // Make a VRTBanner
        let adSize = adConfiguration.adSize
        vrtBanner = VRTBanner(
            frame: CGRect(x: 0, y: 0, width: adSize.size.width, height: adSize.size.height)
        )
        
        // Load
        vrtBanner?.adDelegate = self
        vrtBanner?.loadAd(zoneId)
    }
}


extension VRTGADMediationBannerAd: VRTBannerDelegate {
    func vrtBannerAdLoaded(
        _ vrtBanner: VRTBanner,
        withAdSize adSize: CGSize
    ) {
        VRTLogInfo()
        delegate = completionHandler?(self, nil)
    }
    
    func vrtBannerAdFailedToLoad(
        _ vrtBanner: VRTBanner,
        error: any Error
    ) {
        VRTLogInfo()
        _ = completionHandler?(self, nil)
    }
    
    func vrtBannerAdClicked(
        _ vrtBanner: VRTBanner
    ) {
        VRTLogInfo()
        delegate?.reportClick()
    }
    
    func vrtBannerWillPresentModal(
        _ vrtBanner: VRTBanner,
        of modalType: VRTModalType
    ) {
        VRTLogInfo()
        delegate?.willPresentFullScreenView()
    }
    
    func vrtBannerDidPresentModal(
        _ vrtBanner: VRTBanner,
        of modalType: VRTModalType
    ) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtBannerWillDismissModal(
        _ vrtBanner: VRTBanner,
        of modalType: VRTModalType
    ) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtBannerDidDismissModal(
        _ vrtBanner: VRTBanner,
        of modalType: VRTModalType
    ) {
        VRTLogInfo()
        delegate?.didDismissFullScreenView()
    }
    
    func vrtBannerAdWillLeaveApplication(
        _ vrtBanner: VRTBanner
    ) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtBannerVideoStarted(
        _ vrtBanner: VRTBanner
    ) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtBannerVideoCompleted(
        _ vrtBanner: VRTBanner
    ) {
        VRTLogInfo()
        // No AdMob Equivalent
    }
    
    func vrtViewControllerForModalPresentation() -> UIViewController? {
        VRTLogInfo()
        return nil
    }
}
