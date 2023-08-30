import GoogleMobileAds
import VrtcalSDK

// Google Mobile Ads Interstitial Adapter, Vrtcal as Secondary
// Must be NSObject for GADCustomEventInterstitial
class VRTGADCustomEventInterstitial: NSObject, GADCustomEventInterstitial {
    
    private weak var rootViewController: UIViewController?
    private var vrtInterstitial: VRTInterstitial?
    
    weak var delegate: GADCustomEventInterstitialDelegate?
    
    required override init() {
        super.init()
    }
    
    func requestAd(
        withParameter serverParameter: String?,
        label serverLabel: String?,
        request: GADCustomEventRequest
    ) {
        VRTLogInfo()

        switch VRTGADCustomEventZidExtractor.extract(serverParameter: serverParameter) {
            case .success(let zid):

                // Make VRTInterstitial and load
                vrtInterstitial = VRTInterstitial()
                vrtInterstitial?.adDelegate = self
                vrtInterstitial?.loadAd(zid)
                
            case .failure(let vrtError):
                delegate?.customEventInterstitial(self, didFailAd: vrtError)
        }
    }
    
    func present(fromRootViewController rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        vrtInterstitial?.showAd()
    }
}

// MARK: - VRTInterstitialDelegate
extension VRTGADCustomEventInterstitial: VRTInterstitialDelegate {
    
    func vrtInterstitialAdLoaded(_ vrtInterstitial: VRTInterstitial) {
        delegate?.customEventInterstitialDidReceiveAd(self)
    }

    func vrtInterstitialAdFailed(toLoad vrtInterstitial: VRTInterstitial, error: Error) {
        delegate?.customEventInterstitial(self, didFailAd: error)
    }

    func vrtInterstitialAdWillShow(_ vrtInterstitial: VRTInterstitial) {
        delegate?.customEventInterstitialWillPresent(self)
    }

    func vrtInterstitialAdDidShow(_ vrtInterstitial: VRTInterstitial) {
        //Surprisingly, Google Mobile Ads doesn't have an analog to this event.
    }

    func vrtInterstitialAdFailed(toShow vrtInterstitial: VRTInterstitial, error: Error) {
        delegate?.customEventInterstitial(self, didFailAd: error)
    }

    func vrtInterstitialAdClicked(_ vrtInterstitial: VRTInterstitial) {
        delegate?.customEventInterstitialWasClicked(self)
    }

    func vrtInterstitialAdWillLeaveApplication(_ vrtInterstitial: VRTInterstitial) {
        //Google Mobile Ads supports this event but it is deprecated
        //[self.delegate customEventInterstitialWillLeaveApplication:self];
    }

    func vrtInterstitialAdWillDismiss(_ vrtInterstitial: VRTInterstitial) {
        delegate?.customEventInterstitialWillDismiss(self)
    }

    func vrtInterstitialAdDidDismiss(_ vrtInterstitial: VRTInterstitial) {
        delegate?.customEventInterstitialDidDismiss(self)
    }

    func vrtViewControllerForModalPresentation() -> UIViewController? {
        return rootViewController
    }

    func vrtInterstitialVideoStarted(_ vrtInterstitial: VRTInterstitial) {
        // Google Mobile Ads doesn't have an analog to this event.
    }

    func vrtInterstitialVideoCompleted(_ vrtInterstitial: VRTInterstitial) {
        // Google Mobile Ads doesn't have an analog to this event.
    }
}
