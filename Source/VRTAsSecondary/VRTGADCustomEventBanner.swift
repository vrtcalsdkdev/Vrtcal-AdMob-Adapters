// Google Mobile Ads Banner Adapter, Vrtcal as Secondary

import GoogleMobileAds
import VrtcalSDK

class VRTGADCustomEventBanner: NSObject, GADCustomEventBanner {
    private var vrtBanner: VRTBanner?
    
    // GADCustomEventBanner Requirements
    weak var delegate: GADCustomEventBannerDelegate?
    
    required override init() {
        super.init()
    }
    
    func requestAd(
        _ adSize: GADAdSize,
        parameter serverParameter: String?,
        label serverLabel: String?,
        request: GADCustomEventRequest
    ) {
        VRTLogInfo()
        
        switch VRTGADCustomEventZidExtractor.extract(serverParameter: serverParameter) {
            case .success(let zid):
                // Make VRTBanner and load
                let frame = CGRect(
                    x: 0,
                    y: 0,
                    width: adSize.size.width,
                    height: adSize.size.height
                )
                
                vrtBanner = VRTBanner(
                    frame: frame
                )
                vrtBanner?.adDelegate = self
                vrtBanner?.loadAd(zid)
                
            case .failure(let vrtError):
                delegate?.customEventBanner(self, didFailAd: vrtError)
        }
    }
}

// MARK: VRTBannerDelegate
extension VRTGADCustomEventBanner: VRTBannerDelegate {

    
    func vrtBannerAdLoaded(_ vrtBanner: VRTBanner, withAdSize adSize: CGSize) {
        VRTLogInfo()
        delegate?.customEventBanner(self, didReceiveAd: vrtBanner)
    }

    func vrtBannerAdFailedToLoad(_ vrtBanner: VRTBanner, error: Error) {
        VRTLogInfo()
        delegate?.customEventBanner(self, didFailAd: error)
    }

    func vrtBannerAdClicked(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        delegate?.customEventBannerWasClicked(self)
    }

    func vrtBannerWillPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        delegate?.customEventBannerWillPresentModal(self)
    }

    func vrtBannerDidPresentModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
    }

    func vrtBannerWillDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        delegate?.customEventBannerWillDismissModal(self)
    }

    func vrtBannerDidDismissModal(_ vrtBanner: VRTBanner, of modalType: VRTModalType) {
        VRTLogInfo()
        delegate?.customEventBannerDidDismissModal(self)
    }

    func vrtBannerAdWillLeaveApplication(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        // Google Mobile Ads supports this event but it is deprecated
        delegate?.customEventBannerWillLeaveApplication(self)
    }

    func vrtViewControllerForModalPresentation() -> UIViewController? {
        VRTLogInfo()
        return delegate?.viewControllerForPresentingModalView
    }

    func vrtBannerVideoStarted(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        //Google Mobile Ads doesn't have an analog to this event.
    }

    func vrtBannerVideoCompleted(_ vrtBanner: VRTBanner) {
        VRTLogInfo()
        //Google Mobile Ads doesn't have an analog to this event.
    }
}

