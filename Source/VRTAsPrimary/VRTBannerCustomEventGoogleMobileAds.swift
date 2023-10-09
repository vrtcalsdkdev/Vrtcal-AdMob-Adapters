// Google Mobile Ads Banner Adapter, Vrtcal as Primary

import GoogleMobileAds
import VrtcalSDK

class VRTBannerCustomEventGoogleMobileAds: VRTAbstractBannerCustomEvent {
    private var gadBannerView: GADBannerView?
    private var gadBannerViewDelegatePassthrough: GADBannerViewDelegatePassthrough?
    
    override func loadBannerAd() {
        VRTLogInfo()
        
        // Get AdUnitId
        guard let adUnitId = customEventConfig.thirdPartyCustomEventData["adUnitId"] as? String else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "adUnitId not in customEventConfig.thirdPartyCustomEventData: \(customEventConfig.thirdPartyCustomEventData)"
            )
            customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
            return
        }
        
        // Make GADBannerView
        let gadAdSize = GADAdSize(
            size: customEventConfig.adSize,
            flags: 0
        )
        
        gadBannerView = GADBannerView(adSize: gadAdSize)
        gadBannerView?.adUnitID = adUnitId
        let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation()
        gadBannerView?.rootViewController = vc
        
        // Make Delegate passthrough
        let gadBannerViewDelegatePassthrough = GADBannerViewDelegatePassthrough()
        gadBannerViewDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
        gadBannerViewDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
        gadBannerView?.delegate = gadBannerViewDelegatePassthrough
        self.gadBannerViewDelegatePassthrough = gadBannerViewDelegatePassthrough
        
        // Load
        gadBannerView?.load(GADRequest())
    }
    
    override func getView() -> UIView? {
        VRTLogInfo()
        
        // customEventShowDelegate not set until getView
        gadBannerViewDelegatePassthrough?.customEventShowDelegate = customEventShowDelegate
        
        return gadBannerView
    }
}

// MARK: - GADBannerViewDelegate
class GADBannerViewDelegatePassthrough: NSObject, GADBannerViewDelegate {

    public weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    public weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    
    /// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
    /// the banner view to the view hierarchy if it hasn't been added yet.
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        VRTLogInfo()
        customEventLoadDelegate?.customEventLoaded()
    }

    /// Tells the delegate that an ad request failed. The failure is normally due to network
    /// connectivity or ad availablility (i.e., no fill).
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        VRTLogInfo("error: \(error)")
        let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
        customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
    }

    /// Tells the delegate that an impression has been recorded for an ad.
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        VRTLogInfo()
        // VrtcalSDK does not have an analog for this event
    }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    /// Tells the delegate that a full screen view will be presented in response to the user clicking on
    /// an ad. The delegate may want to pause animations and time sensitive interactions.
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    /// Tells the delegate that the full screen view will be dismissed.
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        VRTLogInfo()
    }

    /// Tells the delegate that the full screen view has been dismissed. The delegate should restart
    /// anything paused while handling adViewWillPresentScreen:.
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        VRTLogInfo()
    }
}

