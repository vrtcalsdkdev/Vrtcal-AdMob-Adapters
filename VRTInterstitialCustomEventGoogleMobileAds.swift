
//
//  VRTInterstitialCustomEventGoogleMobileAds.swift
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//
//  VRTInterstitialCustomEventGoogleMobileAds.swift
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

import VrtcalSDK
import GoogleMobileAds

// Google Mobile Ads Interstitial Adapter, Vrtcal as Primary
class VRTInterstitialCustomEventGoogleMobileAds: VRTAbstractInterstitialCustomEvent {
    private var gadInterstitial: GADInterstitialAd?
    private var gadInterstitialAdDelegatePassthrough: GADInterstitialAdDelegatePassthrough?
    
    override func loadInterstitialAd() {
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
        
        // Load
        GADInterstitialAd.load(withAdUnitID: adUnitId, request: GADRequest()) { [self] interstitialAd, error in
            
            // Validate
            guard error == nil else {
                let vrtError = VRTError(vrtErrorCode: .customEvent, error: error!)
                customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
                return
            }
            
            guard let interstitialAd else {
                let vrtError = VRTError(
                    vrtErrorCode: .customEvent,
                    message: "interstitialAd (GADInterstitialAd) is nil!"
                )
                customEventLoadDelegate?.customEventFailedToLoad(vrtError: vrtError)
                return
            }
            
            // Make a delegate passthrough
            let gadInterstitialAdDelegatePassthrough = GADInterstitialAdDelegatePassthrough()
            gadInterstitialAdDelegatePassthrough.customEventLoadDelegate = customEventLoadDelegate
            gadInterstitialAdDelegatePassthrough.customEventShowDelegate = customEventShowDelegate
            self.gadInterstitialAdDelegatePassthrough = gadInterstitialAdDelegatePassthrough
            
            // Save the GADInterstitial
            gadInterstitial = interstitialAd
            gadInterstitial?.fullScreenContentDelegate = gadInterstitialAdDelegatePassthrough
            
            // Let our delegate know the ad loaded
            customEventLoadDelegate?.customEventLoaded()
        }
    }
    
    override func showInterstitialAd() {
        VRTLogInfo()
        guard let vc = viewControllerDelegate?.vrtViewControllerForModalPresentation() else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "vrtViewControllerForModalPresentation nil"
            )
            
            customEventShowDelegate?.customEventFailedToShow(vrtError: vrtError)
            return
        }
        
        // The customEventShowDelegate is not set until showInterstitialAd
        self.gadInterstitialAdDelegatePassthrough?.customEventShowDelegate = customEventShowDelegate
        
        gadInterstitial?.present(fromRootViewController: vc)
        customEventShowDelegate?.customEventWillPresentModal(.interstitial)
    }
}

class GADInterstitialAdDelegatePassthrough: NSObject, GADFullScreenContentDelegate {

    public weak var customEventLoadDelegate: VRTCustomEventLoadDelegate?
    public weak var customEventShowDelegate: VRTCustomEventShowDelegate?
    
    /// Tells the delegate that an impression has been recorded for the ad.
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        VRTLogInfo()
        //There is no Vrtcal analog for this event
    }

    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventClicked()
    }

    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        VRTLogInfo()
        let vrtError = VRTError(vrtErrorCode: .customEvent, error: error)
        customEventShowDelegate?.customEventFailedToShow(vrtError: vrtError)
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventShown()
        customEventShowDelegate?.customEventWillPresentModal(.interstitial)
    }

    /// Tells the delegate that the ad will dismiss full screen content.
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventWillDismissModal(.interstitial)
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        VRTLogInfo()
        customEventShowDelegate?.customEventDidDismissModal(.interstitial)
    }
}
